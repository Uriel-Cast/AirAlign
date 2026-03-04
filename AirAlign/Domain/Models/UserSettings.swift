// UserSettings.swift
// AirAlign — Domain / Models

import Foundation
import SwiftData

// MARK: — Sensitivity Level

/// Controls the angle threshold and sustained-duration before haptic fires.
enum SensitivityLevel: String, Codable, CaseIterable {
    case low    = "low"
    case medium = "medium"
    case high   = "high"

    var displayName: String { rawValue.capitalized }

    /// Degrees of forward tilt allowed before the timer starts
    var thresholdDegrees: Double {
        switch self {
        case .low:    return 20.0
        case .medium: return 12.0
        case .high:   return 6.0
        }
    }

    /// Continuous seconds to sustain the tilt before haptic fires
    var sustainedSeconds: Double {
        switch self {
        case .low:    return 20.0
        case .medium: return 14.0
        case .high:   return 8.0
        }
    }

    var next: SensitivityLevel {
        switch self {
        case .low:    return .medium
        case .medium: return .high
        case .high:   return .low
        }
    }
}

// MARK: — Posture State

/// The real-time posture evaluation result derived from current angle vs baseline
enum PostureState: String {
    case aligned   = "ALIGNED"
    case slouching = "SLOUCHING"
    case idle      = "IDLE"

    var displayName: String { rawValue }

    var isGood: Bool { self == .aligned }

    var feedbackMessage: String {
        switch self {
        case .aligned:
            return "Great posture! Keep it up."
        case .slouching:
            return "Adjust your posture to avoid a haptic cue."
        case .idle:
            return "Connect AirPods to start monitoring."
        }
    }
}

// MARK: — UserSettings Model

/// Singleton configuration record. Access via `@Query` — always use `.first`.
@Model
final class UserSettings {
    var id: UUID

    // MARK: Calibration
    /// Baseline pitch angle captured during the last calibration (degrees)
    var baselineAngle: Double
    var calibratedAt: Date?

    // MARK: Preferences
    var sensitivity: SensitivityLevel
    var hapticsEnabled: Bool
    var liveActivityEnabled: Bool

    init(
        id: UUID = UUID(),
        baselineAngle: Double = 0,
        sensitivity: SensitivityLevel = .medium,
        hapticsEnabled: Bool = true,
        liveActivityEnabled: Bool = false
    ) {
        self.id = id
        self.baselineAngle = baselineAngle
        self.calibratedAt = nil
        self.sensitivity = sensitivity
        self.hapticsEnabled = hapticsEnabled
        self.liveActivityEnabled = liveActivityEnabled
    }

    var isCalibrated: Bool { calibratedAt != nil }

    var calibrationDescription: String {
        guard let date = calibratedAt else { return "Not calibrated yet." }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return "Last calibrated \(formatter.localizedString(for: date, relativeTo: Date()))"
    }
}
