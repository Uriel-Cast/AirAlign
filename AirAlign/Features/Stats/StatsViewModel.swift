// StatsViewModel.swift
// AirAlign — Features / Stats

import Foundation
import SwiftData
import Observation

/// Derives weekly analytics from DailySummary and PostureSession data.
@Observable
final class StatsViewModel {

    // MARK: — UI State
    private(set) var weeklyScorePercent: Int = 0
    private(set) var weeklySessionCount: Int = 0
    private(set) var weeklyAlertCount: Int = 0
    private(set) var chartData: [ChartBar] = []
    private(set) var dailyBreakdown: [DailyRow] = []
    private(set) var featuredSession: PostureSession?

    struct ChartBar: Identifiable {
        let id: UUID
        let dayLabel: String     // "M", "T", "W" etc
        let score: Double        // 0.0–1.0
        let isToday: Bool
    }

    struct DailyRow: Identifiable {
        let id: UUID
        let dayName: String
        let scorePercent: Int
        let alertCount: Int
    }

    // MARK: — Load

    func load(summaries: [DailySummary], sessions: [PostureSession]) {
        let week = lastSevenDays()

        weeklyScorePercent = Int(PostureEvaluator.weeklyScore(from: summaries) * 100)
        weeklyAlertCount = PostureEvaluator.weeklyAlerts(from: summaries)
        weeklySessionCount = summaries.reduce(0) { $0 + $1.totalSessions }

        // Build chart bars for last 7 days (Mon–Sun order in current week)
        let dayFmt = DateFormatter()
        dayFmt.dateFormat = "EEEEE"
        chartData = week.map { date in
            let summary = summaries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
            return ChartBar(
                id: UUID(),
                dayLabel: dayFmt.string(from: date),
                score: summary?.goodPostureScore ?? 0,
                isToday: Calendar.current.isDateInToday(date)
            )
        }

        // Daily breakdown list
        dailyBreakdown = summaries
            .sorted { $0.date > $1.date }
            .map { s in
                DailyRow(
                    id: s.id,
                    dayName: s.formattedDate,
                    scorePercent: s.scorePercent,
                    alertCount: s.alertCount
                )
            }

        // Featured session = longest completed this week
        featuredSession = sessions
            .filter { !$0.isActive }
            .sorted { $0.totalDurationSeconds > $1.totalDurationSeconds }
            .first
    }

    // MARK: — Helpers

    private func lastSevenDays() -> [Date] {
        let calendar = Calendar.current
        return (0..<7).reversed().compactMap {
            calendar.date(byAdding: .day, value: -$0, to: calendar.startOfDay(for: Date()))
        }
    }
}
