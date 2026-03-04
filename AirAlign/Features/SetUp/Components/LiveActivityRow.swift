// LiveActivityRow.swift
// AirAlign — Features / SetUp / Components

import SwiftUI

struct LiveActivityRow: View {
    let statusLabel: String
    let isEnabled: Bool
    let onToggle: () -> Void

    var body: some View {
        StatCard {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Live Activity")
                        .font(.aaHeadline)
                        .foregroundStyle(Color.aaPrimary)
                    Text("Back status visible in other apps.")
                        .font(.aaBody)
                        .foregroundStyle(Color.aaSecondary)
                }
                Spacer()
                Button(action: onToggle) {
                    BadgePill(text: statusLabel, style: .outlined)
                }
            }
        }
    }
}
