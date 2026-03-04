// StatMetricCard.swift
// AirAlign — Features / Log / Components

import SwiftUI

struct StatMetricCard: View {
    let label: String
    let value: String

    var body: some View {
        StatCard {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(label)
                    .sectionCaption()
                Text(value)
                    .font(.aaMetricMd)
                    .foregroundStyle(Color.aaPrimary)
            }
        }
    }
}

#Preview {
    HStack {
        StatMetricCard(label: "Sessions", value: "6")
        StatMetricCard(label: "Haptics", value: "14")
    }
    .padding()
    .background(Color.aaBackground)
}
