// PostureEvaluator.swift
// AirAlign — Services

import Foundation

/// Stateless logic module — converts raw angle + settings into actionable posture state.
/// No hardware access. No side effects.
struct PostureEvaluator {

    // MARK: — Posture State

    /// Determines the current posture state.
    /// - Parameters:
    ///   - angle: Current pitch in degrees (negative = forward tilt)
    ///   - baseline: Calibrated neutral pitch in degrees
    ///   - settings: Current user settings (threshold)
    ///   - isConnected: Whether AirPods are connected
    static func evaluate(
        angle: Double,
        baseline: Double,
        settings: UserSettings,
        isConnected: Bool
    ) -> PostureState {
        guard isConnected else { return .idle }

        let deviation = baseline - angle   // positive when head is forward of baseline
        return deviation > settings.sensitivity.thresholdDegrees ? .slouching : .aligned
    }

    // MARK: — Good Posture Ratio

    /// Returns the fraction of total session time spent in aligned state.
    static func goodPostureRatio(uprightSeconds: Int, totalSeconds: Int) -> Double {
        guard totalSeconds > 0 else { return 0 }
        return min(Double(uprightSeconds) / Double(totalSeconds), 1.0)
    }

    // MARK: — Haptic Countdown

    /// Returns the countdown (in seconds) until a haptic fires, given how long
    /// the user has been slouching continuously.
    static func hapticCountdown(
        slouchDuration: TimeInterval,
        settings: UserSettings
    ) -> TimeInterval {
        max(settings.sensitivity.sustainedSeconds - slouchDuration, 0)
    }

    // MARK: — Angle Display

    /// Formats a raw pitch angle into a user-facing string like "-12°"
    static func formatAngle(_ degrees: Double) -> String {
        let rounded = Int(degrees.rounded())
        return "\(rounded >= 0 ? "+" : "")\(rounded)°"
    }

    // MARK: — Weekly Stats

    /// Computes the weekly average score from DailySummary entries.
    static func weeklyScore(from summaries: [DailySummary]) -> Double {
        guard !summaries.isEmpty else { return 0 }
        let total = summaries.reduce(0.0) { $0 + $1.goodPostureScore }
        return total / Double(summaries.count)
    }

    /// Total haptic alerts across a collection of daily summaries.
    static func weeklyAlerts(from summaries: [DailySummary]) -> Int {
        summaries.reduce(0) { $0 + $1.alertCount }
    }
}
