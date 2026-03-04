// LiveViewModel.swift
// AirAlign — Features / Live

import Foundation
import SwiftData
import Observation

/// Exposes all Live-screen UI state.
/// Subscribes to SessionManager and MotionManager; performs no hardware access directly.
@Observable
final class LiveViewModel {

    // MARK: — UI State (derived from services)
    private(set) var currentAngle: Double = 0
    private(set) var postureState: PostureState = .idle
    private(set) var goodPosturePercent: Int = 0
    private(set) var timeUprightFormatted: String = "0M"
    private(set) var countdownToHaptic: TimeInterval = 0
    private(set) var isSessionActive: Bool = false
    private(set) var isAirPodsConnected: Bool = false

    // Bar chart data: last 5 time segments
    private(set) var uprightBarData: [Double] = Array(repeating: 0, count: 5)

    // MARK: — Dependencies
    private let sessionManager: SessionManager
    private let motionManager: MotionManager

    init(sessionManager: SessionManager, motionManager: MotionManager) {
        self.sessionManager = sessionManager
        self.motionManager = motionManager
    }

    // MARK: — Actions

    func startSession(settings: UserSettings, context: ModelContext) {
        motionManager.start()
        sessionManager.start(settings: settings, motionManager: motionManager, context: context)
        isSessionActive = true
    }

    func stopSession(context: ModelContext) {
        sessionManager.stop(context: context)
        motionManager.stop()
        isSessionActive = false
    }

    // MARK: — Sync (called from view via .task or timer)

    func syncState() {
        currentAngle = motionManager.currentPitch
        postureState = sessionManager.currentState
        goodPosturePercent = Int(sessionManager.goodPostureRatio * 100)
        countdownToHaptic = sessionManager.countdownToHaptic
        isAirPodsConnected = motionManager.isAvailable

        if let session = sessionManager.activeSession {
            timeUprightFormatted = formatUpright(seconds: session.uprightDurationSeconds)
        }
    }

    // MARK: — Helpers

    private func formatUpright(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        return h > 0 ? "\(h)H \(String(format: "%02d", m))M" : "\(m)M"
    }

    var angleFormatted: String {
        PostureEvaluator.formatAngle(currentAngle)
    }

    var hapticCountdownLabel: String {
        let s = Int(countdownToHaptic)
        return "Haptic feedback in \(s)s if neck angle stays below target."
    }
}
