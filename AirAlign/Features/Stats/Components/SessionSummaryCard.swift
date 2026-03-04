// SessionSummaryCard.swift
// AirAlign — Features / Stats / Components

import SwiftUI

struct SessionSummaryCard: View {
    let session: PostureSession?
    let hapticCount: Int

    var body: some View {
        HStack(spacing: Spacing.md) {
            // Longest session card
            StatCard {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    if let session {
                        Text(session.formattedDuration)
                            .font(.aaMetricMd)
                            .foregroundStyle(Color.aaPrimary)
                        Text(session.dayLabel)
                            .font(.aaBody)
                            .foregroundStyle(Color.aaSecondary)
                        Text(session.formattedTimeRange)
                            .font(.aaCaption)
                            .foregroundStyle(Color.aaSecondary)
                    } else {
                        Text("—")
                            .font(.aaMetricLg)
                            .foregroundStyle(Color.aaTertiary)
                        Text("No sessions yet")
                            .font(.aaBody)
                            .foregroundStyle(Color.aaTertiary)
                    }
                }
            }

            // Haptic count card
            StatCard {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("\(hapticCount)")
                        .font(.aaMetricMd)
                        .foregroundStyle(Color.aaPrimary)
                    Text("Gentle haptics triggered before prolonged slouching.")
                        .font(.aaBody)
                        .foregroundStyle(Color.aaSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
