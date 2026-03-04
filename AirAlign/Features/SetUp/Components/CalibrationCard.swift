// CalibrationCard.swift
// AirAlign — Features / SetUp / Components

import SwiftUI

struct CalibrationCard: View {
    let statusLabel: String
    let isCalibrating: Bool
    let progress: Double
    let onRun: () -> Void

    var body: some View {
        StatCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                SectionLabel(text: "Neutral Calibration")

                Text("Sit upright, look forward, and let AirPods capture your baseline posture.")
                    .font(.aaBody)
                    .foregroundStyle(Color.aaSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if isCalibrating {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        ProgressView(value: progress)
                            .tint(Color.aaMint)
                        Text(statusLabel)
                            .font(.aaCaption)
                            .foregroundStyle(Color.aaSecondary)
                    }
                } else {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        PrimaryButton(title: "Run Calibration", action: onRun)

                        Text(statusLabel)
                            .font(.aaCaption)
                            .foregroundStyle(Color.aaTertiary)
                    }
                }
            }
        }
    }
}
