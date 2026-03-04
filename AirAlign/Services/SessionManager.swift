// SessionManager.swift
// AirAlign — Services

import Foundation
import SwiftData
import Observation

/// Orchestrates the full session lifecycle:
/// 1. start() — creates PostureSession, begins motion evaluation loop
/// 2. Real-time angle evaluation via PostureEvaluator
/// 3. Haptic firing via HapticService when conditions are met
/// 4. Event recording into the active session
/// 5. stop() — finalises session, writes DailySummary, marks isActive = false
@Observable
final class SessionManager {

    // MARK: — Published State
    private(set) var activeSession: PostureSession?
    private(set) var currentState: PostureState = .idle
    private(set) var goodPostureRatio: Double = 0
    private(set) var countdownToHaptic: TimeInterval = 0

    // MARK: — Private Tracking
    private var slouchStartTime: Date?
    private var uprightStartTime: Date?
    private var evaluationTimer: Timer?
    private var sessionStartTime: Date?
    private var lastStreakTime: Date?

    // MARK: — Dependencies (injected, not stored permanently)
    private let hapticService = HapticService.shared

    // MARK: — Session Control

    /// Start a new session. Must pass in modelContext for SwiftData writes.
    func start(
        settings: UserSettings,
        motionManager: MotionManager,
        context: ModelContext
    ) {
        guard activeSession == nil else { return }

        let session = PostureSession(
            startedAt: Date(),
            baselineAngle: settings.baselineAngle,
            isActive: true
        )
        context.insert(session)
        activeSession = session
        sessionStartTime = Date()
        uprightStartTime = Date()
        currentState = .aligned

        let startEvent = PostureEvent(
            type: .sessionStart,
            detail: "Baseline angle locked after \(Int(settings.sensitivity.sustainedSeconds)) seconds of neutral posture.",
            angleAtEvent: motionManager.currentPitch
        )
        session.events.append(startEvent)
        context.insert(startEvent)

        startEvaluationLoop(settings: settings, motionManager: motionManager, context: context)
    }

    func stop(context: ModelContext) {
        evaluationTimer?.invalidate()
        evaluationTimer = nil

        guard let session = activeSession else { return }

        session.endedAt = Date()
        session.isActive = false

        if let start = sessionStartTime {
            session.totalDurationSeconds = Int(Date().timeIntervalSince(start))
        }
        session.goodPostureScore = PostureEvaluator.goodPostureRatio(
            uprightSeconds: session.uprightDurationSeconds,
            totalSeconds: session.totalDurationSeconds
        )

        let endEvent = PostureEvent(
            type: .sessionEnd,
            detail: "Session ended. Score: \(session.scorePercent)%",
            angleAtEvent: nil
        )
        session.events.append(endEvent)
        context.insert(endEvent)

        updateDailySummary(for: session, context: context)

        activeSession = nil
        currentState = .idle
        slouchStartTime = nil
        uprightStartTime = nil
        sessionStartTime = nil
    }

    // MARK: — Evaluation Loop

    private func startEvaluationLoop(
        settings: UserSettings,
        motionManager: MotionManager,
        context: ModelContext
    ) {
        evaluationTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] _ in
            self?.evaluate(settings: settings, motionManager: motionManager, context: context)
        }
    }

    private func evaluate(
        settings: UserSettings,
        motionManager: MotionManager,
        context: ModelContext
    ) {
        guard let session = activeSession else { return }

        let newState = PostureEvaluator.evaluate(
            angle: motionManager.currentPitch,
            baseline: settings.baselineAngle,
            settings: settings,
            isConnected: !motionManager.isSimulating || motionManager.isAvailable
        )

        let now = Date()

        // Update upright time tracking
        if newState == .aligned {
            session.uprightDurationSeconds += 1
            if let ss = slouchStartTime {
                // Transitioned from slouch → aligned — check for recovery streak
                let slouchDuration = now.timeIntervalSince(ss)
                if slouchDuration < 5 {
                    checkRecoveryStreak(session: session, context: context)
                }
                slouchStartTime = nil
            }
            countdownToHaptic = settings.sensitivity.sustainedSeconds
        } else if newState == .slouching {
            if slouchStartTime == nil { slouchStartTime = now }
            let slouchDuration = now.timeIntervalSince(slouchStartTime!)
            countdownToHaptic = PostureEvaluator.hapticCountdown(slouchDuration: slouchDuration, settings: settings)

            if slouchDuration >= settings.sensitivity.sustainedSeconds && settings.hapticsEnabled {
                fireHapticCue(
                    session: session,
                    angle: motionManager.currentPitch,
                    context: context
                )
                slouchStartTime = now   // reset so it can fire again after another full interval
            }
        }

        // Update total duration
        if let start = sessionStartTime {
            session.totalDurationSeconds = Int(now.timeIntervalSince(start))
        }

        goodPostureRatio = PostureEvaluator.goodPostureRatio(
            uprightSeconds: session.uprightDurationSeconds,
            totalSeconds: max(session.totalDurationSeconds, 1)
        )
        currentState = newState
    }

    private func fireHapticCue(session: PostureSession, angle: Double, context: ModelContext) {
        hapticService.firePostureCue()
        session.hapticCount += 1

        let event = PostureEvent(
            type: .hapticCue,
            detail: "A subtle tap was sent after \(Int(activeSession.map { _ in 14 } ?? 14)) seconds of sustained forward tilt.",
            angleAtEvent: angle
        )
        session.events.append(event)
        context.insert(event)
    }

    private func checkRecoveryStreak(session: PostureSession, context: ModelContext) {
        // Only log a streak if the upright window was meaningful (≥ 10 min)
        guard let uprightStart = uprightStartTime else { return }
        let uprightMinutes = Int(Date().timeIntervalSince(uprightStart) / 60)
        guard uprightMinutes >= 10 else {
            uprightStartTime = Date()
            return
        }

        hapticService.fireRecoveryStreak()
        let event = PostureEvent(
            type: .recoveryStreak,
            detail: "Stayed inside the target posture band for \(uprightMinutes) minutes straight.",
            angleAtEvent: nil
        )
        session.events.append(event)
        context.insert(event)
        uprightStartTime = Date()
    }

    // MARK: — Daily Summary Update

    private func updateDailySummary(for session: PostureSession, context: ModelContext) {
        let today = DailySummary.normalizedDate(Date())

        // Try to find existing summary for today
        let descriptor = FetchDescriptor<DailySummary>(
            predicate: #Predicate { $0.date == today }
        )

        if let existing = try? context.fetch(descriptor).first {
            // Merge into existing
            let prevSessions = existing.totalSessions
            existing.totalSessions += 1
            existing.alertCount += session.hapticCount
            existing.totalUprightSeconds += session.uprightDurationSeconds
            // Weighted average of posture scores
            existing.goodPostureScore = (existing.goodPostureScore * Double(prevSessions) + session.goodPostureScore) / Double(existing.totalSessions)
        } else {
            let summary = DailySummary(
                date: today,
                goodPostureScore: session.goodPostureScore,
                alertCount: session.hapticCount,
                totalSessions: 1,
                totalUprightSeconds: session.uprightDurationSeconds
            )
            context.insert(summary)
        }
    }
}
