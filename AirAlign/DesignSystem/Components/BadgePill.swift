// BadgePill.swift
// AirAlign — Design System / Components

import SwiftUI

/// Green pill badge for status labels (ACTIVE, MEDIUM, READY) and CTAs.
/// `style` controls whether the pill is filled (primary) or outlined (secondary).
struct BadgePill: View {
    let text: String
    var style: BadgePillStyle = .filled

    enum BadgePillStyle {
        case filled    // solid mint — used for ACTIVE, MEDIUM, button-like states
        case outlined  // border only — used for READY / secondary states
    }

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .bold, design: .default))
            .tracking(0.5)
            .textCase(.uppercase)
            .foregroundStyle(style == .filled ? Color.aaPrimary : Color.aaMint)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.xs)
            .background(
                Group {
                    if style == .filled {
                        Color.aaMint
                    } else {
                        Color.aaMintSubtle
                    }
                }
            )
            .clipShape(Capsule())
            .overlay(
                Group {
                    if style == .outlined {
                        Capsule().stroke(Color.aaMint, lineWidth: 1.5)
                    }
                }
            )
    }
}

// MARK: — Large CTA Button variant
struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .bold, design: .default))
                .tracking(0.8)
                .textCase(.uppercase)
                .foregroundStyle(Color.aaPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(Color.aaMint)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        HStack {
            BadgePill(text: "Active")
            BadgePill(text: "Medium")
            BadgePill(text: "Ready", style: .outlined)
        }
        PrimaryButton(title: "Run Calibration") { }
    }
    .padding()
    .background(Color.aaBackground)
}
