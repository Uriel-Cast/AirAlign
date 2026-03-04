// PostureEvent.swift
// AirAlign — Domain / Models

import Foundation
import SwiftData

// MARK: — Event Type

/// All discrete, timestamped occurrences recorded during a posture session.
enum EventType: String, Codable, CaseIterable {
    case sessionStart    = "session_start"
    case hapticCue       = "haptic_cue"
    case recoveryStreak  = "recovery_streak"
    case sessionEnd      = "session_end"
    case calibration     = "calibration"

    var displayTitle: String {
        switch self {
        case .sessionStart:   return "Session started"
        case .hapticCue:      return "Haptic cue"
        case .recoveryStreak: return "Recovery streak"
        case .sessionEnd:     return "Session ended"
        case .calibration:    return "Calibration"
        }
    }

    /// true → shown with bright green dot; false → darker indicator
    var isPositive: Bool {
        switch self {
        case .sessionStart, .recoveryStreak, .calibration: return true
        case .hapticCue, .sessionEnd: return false
        }
    }
}

// MARK: — PostureEvent Model

@Model
final class PostureEvent {
    var id: UUID
    var timestamp: Date
    var type: EventType
    /// Human-readable description shown in the Log timeline
    var detail: String
    /// Snapshot of the head pitch angle at the moment of the event (degrees)
    var angleAtEvent: Double?
    /// Back-reference to the owning session (inverse of PostureSession.events)
    var session: PostureSession?

    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        type: EventType,
        detail: String,
        angleAtEvent: Double? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self.detail = detail
        self.angleAtEvent = angleAtEvent
        self.session = nil
    }
}
