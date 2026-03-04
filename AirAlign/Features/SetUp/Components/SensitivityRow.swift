// SensitivityRow.swift
// AirAlign — Features / SetUp / Components

import SwiftUI

struct SensitivityRow: View {
    let level: SensitivityLevel
    let onTap: () -> Void

    var body: some View {
        StatCard {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Sensitivity")
                        .font(.aaHeadline)
                        .foregroundStyle(Color.aaPrimary)
                    Text("\(level.displayName) threshold before haptic feedback.")
                        .font(.aaBody)
                        .foregroundStyle(Color.aaSecondary)
                }
                Spacer()
                Button(action: onTap) {
                    BadgePill(text: level.displayName)
                }
            }
        }
    }
}
