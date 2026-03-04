// WeeklyChartCard.swift
// AirAlign — Features / Stats / Components

import SwiftUI

struct WeeklyChartCard: View {
    let scorePercent: Int
    let sessionCount: Int
    let bars: [StatsViewModel.ChartBar]

    var body: some View {
        StatCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(scorePercent)")
                                .font(.aaDisplay)
                                .foregroundStyle(Color.aaPrimary)
                            Text("%")
                                .font(.aaMetricMd)
                                .foregroundStyle(Color.aaPrimary)
                        }
                    }
                    Spacer()
                    BadgePill(text: "+\(sessionCount) this week")
                }

                // Bar chart
                HStack(alignment: .bottom, spacing: Spacing.xs) {
                    ForEach(bars) { bar in
                        VStack(spacing: Spacing.xxs) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(bar.isToday ? Color.aaMint : Color.aaMintMuted.opacity(0.35 + bar.score * 0.65))
                                .frame(maxWidth: .infinity, minHeight: 8)
                                .frame(height: max(8, 56 * bar.score))

                            Text(bar.dayLabel)
                                .font(.aaCaption)
                                .foregroundStyle(bar.isToday ? Color.aaMint : Color.aaSecondary)
                        }
                    }
                }
                .frame(height: 64)
                .animation(.easeInOut, value: bars.map { $0.score })
            }
        }
    }
}
