// PostureGaugeCard.swift
// AirAlign — Features / Live / Components

import SwiftUI

struct PostureGaugeCard: View {
    let scorePercent: Int
    let angleDegrees: Double
    let angleFormatted: String

    var body: some View {
        StatCard {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    // Score
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(scorePercent)")
                            .font(.aaDisplay)
                            .foregroundStyle(Color.aaPrimary)
                        Text("%")
                            .font(.aaMetricMd)
                            .foregroundStyle(Color.aaPrimary)
                    }
                    Text("Good Posture Today")
                        .sectionCaption()

                    Spacer(minLength: Spacing.xs)

                    Text("Live tilt from Motion API")
                        .font(.aaBody)
                        .foregroundStyle(Color.aaSecondary)
                }

                Spacer()

                VStack(alignment: .center, spacing: Spacing.xs) {
                    PostureIcon(angleDegrees: angleDegrees)
                        .frame(width: 64, height: 90)

                    Text(angleFormatted)
                        .font(.aaMetricSm)
                        .foregroundStyle(Color.aaMint)
                }
            }
            .padding(.bottom, Spacing.xs)
        }
    }
}

#Preview {
    PostureGaugeCard(scorePercent: 87, angleDegrees: -12, angleFormatted: "-12°")
        .padding()
        .background(Color.aaBackground)
}
