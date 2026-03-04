// HapticService.swift
// AirAlign — Services

import UIKit

/// Thin wrapper around UIFeedbackGenerator.
/// All haptic calls are no-ops when `hapticsEnabled` is false.
final class HapticService {

    static let shared = HapticService()

    private let impact = UIImpactFeedbackGenerator(style: .medium)
    private let notification = UINotificationFeedbackGenerator()

    private init() {}

    /// Fires a medium impact haptic — used for "subtle tap" posture reminders
    func firePostureCue() {
        impact.prepare()
        impact.impactOccurred()
    }

    /// Fires a success notification haptic — used for recovery streak acknowledgement
    func fireRecoveryStreak() {
        notification.prepare()
        notification.notificationOccurred(.success)
    }

    /// Fires a warning notification haptic — used for persistent slouch alert
    func fireWarning() {
        notification.prepare()
        notification.notificationOccurred(.warning)
    }
}
