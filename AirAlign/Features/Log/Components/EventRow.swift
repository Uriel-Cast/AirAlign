// EventRow.swift
// AirAlign — Features / Log / Components

import SwiftUI

struct EventRow: View {
    let event: PostureEvent

    private var dotColor: Color {
        event.type.isPositive ? Color.aaMint : Color.aaMintMuted
    }

    private var timeLabel: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm"
        return fmt.string(from: event.timestamp)
    }

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            // Dot indicator
            Circle()
                .fill(dotColor)
                .frame(width: 12, height: 12)
                .padding(.top, 3)

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("\(timeLabel)  ·  \(event.type.displayTitle)")
                    .font(.aaLogTitle)
                    .foregroundStyle(Color.aaPrimary)

                Text(event.detail)
                    .font(.aaLogBody)
                    .foregroundStyle(Color.aaSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
