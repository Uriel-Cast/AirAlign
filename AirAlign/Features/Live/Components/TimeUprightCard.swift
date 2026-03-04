// TimeUprightCard.swift
// AirAlign — Features / Live / Components

import SwiftUI

struct TimeUprightCard: View {
    let formattedTime: String
    /// Bar chart data: 0.0–1.0 values for last N time segments
    let barData: [Double]

    var body: some View {
        StatCard {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Time Upright")
                    .sectionCaption()

                Text(formattedTime)
                    .font(.aaMetricMd)
                    .foregroundStyle(Color.aaPrimary)

                // Mini bar chart
                HStack(alignment: .bottom, spacing: Spacing.xs) {
                    ForEach(Array(barData.enumerated()), id: \.offset) { index, value in
                        let isLatest = index == barData.count - 1
                        RoundedRectangle(cornerRadius: 6)
                            .fill(isLatest ? Color.aaMint : Color.aaMintMuted.opacity(0.5 + value * 0.5))
                            .frame(maxWidth: .infinity, minHeight: 8, maxHeight: 36)
                            .frame(height: max(8, 36 * value))
                    }
                }
                .frame(height: 36)
                .animation(.easeInOut, value: barData.map { $0 })
            }
        }
    }
}

#Preview {
    TimeUprightCard(
        formattedTime: "4H 12M",
        barData: [0.3, 0.5, 0.4, 0.8, 0.9]
    )
    .padding()
    .background(Color.aaBackground)
}
