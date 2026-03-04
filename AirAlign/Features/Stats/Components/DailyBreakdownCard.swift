// DailyBreakdownCard.swift
// AirAlign — Features / Stats / Components

import SwiftUI

struct DailyBreakdownCard: View {
    let rows: [StatsViewModel.DailyRow]

    var body: some View {
        StatCard {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                SectionLabel(text: "Daily Breakdown")

                if rows.isEmpty {
                    Text("No data yet this week.")
                        .font(.aaBody)
                        .foregroundStyle(Color.aaTertiary)
                } else {
                    ForEach(rows) { row in
                        HStack {
                            Text(row.dayName)
                                .font(.aaHeadline)
                                .foregroundStyle(Color.aaPrimary)

                            Spacer()

                            Text("\(row.scorePercent)%  ·  \(row.alertCount) \(row.alertCount == 1 ? "alert" : "alerts")")
                                .font(.aaLogTitle)
                                .foregroundStyle(Color.aaMint)
                        }
                        .padding(.vertical, Spacing.xxs)

                        if row.id != rows.last?.id {
                            Divider()
                                .background(Color.aaCardBorder)
                        }
                    }
                }
            }
        }
    }
}
