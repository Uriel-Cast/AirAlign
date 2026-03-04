// DailySummary.swift
// AirAlign — Domain / Models

import Foundation
import SwiftData

/// Denormalized per-day aggregate — computed and stored at session-end.
/// Enables O(1) Stats queries without scanning all PostureEvents.
@Model
final class DailySummary {
    var id: UUID
    /// Date normalized to midnight UTC (used as unique key per day)
    var date: Date
    /// Weighted average posture score across all sessions that day (0.0–1.0)
    var goodPostureScore: Double
    /// Total haptic alerts fired across all sessions that day
    var alertCount: Int
    /// Number of completed sessions that day
    var totalSessions: Int
    /// Total seconds spent in good posture that day
    var totalUprightSeconds: Int

    init(
        id: UUID = UUID(),
        date: Date,
        goodPostureScore: Double = 0,
        alertCount: Int = 0,
        totalSessions: Int = 0,
        totalUprightSeconds: Int = 0
    ) {
        self.id = id
        self.date = DailySummary.normalizedDate(date)
        self.goodPostureScore = goodPostureScore
        self.alertCount = alertCount
        self.totalSessions = totalSessions
        self.totalUprightSeconds = totalUprightSeconds
    }

    // MARK: — Computed

    var scorePercent: Int { Int(goodPostureScore * 100) }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    // MARK: — Helpers

    static func normalizedDate(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    static func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}
