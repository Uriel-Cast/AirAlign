// PostureSession.swift
// AirAlign — Domain / Models

import Foundation
import SwiftData

@Model
final class PostureSession {
    var id: UUID
    var startedAt: Date
    var endedAt: Date?

    /// 0.0–1.0: fraction of active session time within good posture band
    var goodPostureScore: Double

    /// Baseline pitch captured at calibration (degrees)
    var baselineAngle: Double

    /// Total seconds from startedAt to endedAt
    var totalDurationSeconds: Int

    /// Seconds spent within acceptable posture tolerance band
    var uprightDurationSeconds: Int

    /// Number of haptic cues fired during this session
    var hapticCount: Int

    /// Whether this session is still in progress
    var isActive: Bool

    /// All discrete events recorded during this session (cascade-deletes on session removal)
    @Relationship(deleteRule: .cascade, inverse: \PostureEvent.session)
    var events: [PostureEvent]

    init(
        id: UUID = UUID(),
        startedAt: Date = Date(),
        baselineAngle: Double = 0,
        isActive: Bool = true
    ) {
        self.id = id
        self.startedAt = startedAt
        self.endedAt = nil
        self.goodPostureScore = 0
        self.baselineAngle = baselineAngle
        self.totalDurationSeconds = 0
        self.uprightDurationSeconds = 0
        self.hapticCount = 0
        self.isActive = isActive
        self.events = []
    }

    // MARK: — Computed Presentation Helpers

    var formattedDuration: String {
        let hours = totalDurationSeconds / 3600
        let minutes = (totalDurationSeconds % 3600) / 60
        if hours > 0 {
            return "\(hours)H \(String(format: "%02d", minutes))M"
        }
        return "\(minutes)M"
    }

    var formattedTimeRange: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm"
        let start = fmt.string(from: startedAt)
        let end = endedAt.map { fmt.string(from: $0) } ?? "ongoing"
        return "\(start)–\(end)"
    }

    var scorePercent: Int { Int(goodPostureScore * 100) }

    var dayLabel: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEEE"
        return fmt.string(from: startedAt)
    }
}
