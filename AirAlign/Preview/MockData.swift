// MockData.swift
// AirAlign — Preview

import Foundation
import SwiftData

/// Provides ready-made sample data for SwiftUI Previews.
/// All instances use a shared in-memory ModelContainer.
enum MockData {

    // MARK: — Settings
    static var defaultSettings: UserSettings {
        let s = UserSettings(
            baselineAngle: -2.5,
            sensitivity: .medium,
            hapticsEnabled: true,
            liveActivityEnabled: false
        )
        s.calibratedAt = Calendar.current.date(byAdding: .hour, value: -3, to: Date())
        return s
    }

    // MARK: — Sessions
    static func sampleSession(
        startOffset: TimeInterval = -7800,   // ~2h 10m ago
        durationSeconds: Int = 7680,
        scorePercent: Double = 0.87,
        haptics: Int = 4
    ) -> PostureSession {
        let session = PostureSession(startedAt: Date(timeIntervalSinceNow: startOffset))
        session.totalDurationSeconds = durationSeconds
        session.uprightDurationSeconds = Int(Double(durationSeconds) * scorePercent)
        session.goodPostureScore = scorePercent
        session.hapticCount = haptics
        session.endedAt = Date(timeIntervalSinceNow: startOffset + Double(durationSeconds))
        session.isActive = false
        return session
    }

    // MARK: — Events
    static func sampleEvents(for session: PostureSession) -> [PostureEvent] {
        [
            PostureEvent(
                timestamp: session.startedAt,
                type: .sessionStart,
                detail: "Baseline angle locked after 8 seconds of neutral posture.",
                angleAtEvent: -2.5
            ),
            PostureEvent(
                timestamp: session.startedAt.addingTimeInterval(3600),
                type: .hapticCue,
                detail: "A subtle tap was sent after 14 seconds of sustained forward tilt.",
                angleAtEvent: -18.0
            ),
            PostureEvent(
                timestamp: session.startedAt.addingTimeInterval(5400),
                type: .recoveryStreak,
                detail: "Stayed inside the target posture band for 52 minutes straight.",
                angleAtEvent: -3.0
            ),
        ]
    }

    // MARK: — Daily Summaries (last 7 days)
    static var weeklySummaries: [DailySummary] {
        let scores: [(Double, Int)] = [
            (0.89, 3), (0.94, 1), (0.72, 6),
            (0.92, 2), (0.88, 4), (0.0, 0), (0.0, 0)
        ]
        return scores.enumerated().map { index, data in
            let date = Calendar.current.date(
                byAdding: .day,
                value: -(6 - index),
                to: Calendar.current.startOfDay(for: Date())
            )!
            return DailySummary(
                date: date,
                goodPostureScore: data.0,
                alertCount: data.1,
                totalSessions: data.1 > 0 ? 1 : 0,
                totalUprightSeconds: Int(data.0 * 7200)
            )
        }
    }

    // MARK: — Populated Container
    @MainActor
    static func makeContainer() throws -> ModelContainer {
        let container = try ModelContainerFactory.makePreviewContainer()
        let ctx = container.mainContext

        let settings = defaultSettings
        ctx.insert(settings)

        let session = sampleSession()
        ctx.insert(session)

        for event in sampleEvents(for: session) {
            event.session = session
            ctx.insert(event)
        }

        for summary in weeklySummaries {
            ctx.insert(summary)
        }

        return container
    }
}
