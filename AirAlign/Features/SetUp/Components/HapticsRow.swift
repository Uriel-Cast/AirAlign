// HapticsRow.swift
// AirAlign — Features / SetUp / Components

import SwiftUI

struct HapticsRow: View {
    let isEnabled: Bool
    let onToggle: () -> Void

    var body: some View {
        StatCard {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("Haptics")
                        .font(.aaHeadline)
                        .foregroundStyle(Color.aaPrimary)
                    Text("Subtle iPhone pulse when slouch persists.")
                        .font(.aaBody)
                        .foregroundStyle(Color.aaSecondary)
                }
                Spacer()
                Toggle("", isOn: Binding(get: { isEnabled }, set: { _ in onToggle() }))
                    .tint(Color.aaMint)
                    .labelsHidden()
            }
        }
    }
}
