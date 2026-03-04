// StatCard.swift
// AirAlign — Design System / Components

import SwiftUI

/// Generic card container used across Live, Stats, and Log screens.
/// Provides consistent background, border, corner radius, and padding.
struct StatCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.aaCard)
            .clipShape(RoundedRectangle(cornerRadius: Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(Color.aaCardBorder, lineWidth: 1)
            )
    }
}

#Preview {
    StatCard {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("TIME UPRIGHT")
                .sectionCaption()
            Text("4H 12M")
                .font(.aaMetricLg)
                .foregroundStyle(Color.aaPrimary)
        }
    }
    .padding()
    .background(Color.aaBackground)
}
