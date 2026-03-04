// CurrentStateCard.swift
// AirAlign — Features / Live / Components

import SwiftUI

struct CurrentStateCard: View {
    let postureState: PostureState
    let contextMessage: String

    private var stateColor: Color {
        switch postureState {
        case .aligned:   return Color.aaMint
        case .slouching: return Color.aaWarning
        case .idle:      return Color.aaSecondary
        }
    }

    var body: some View {
        StatCard {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Current State")
                    .sectionCaption()

                Text(postureState.displayName)
                    .font(.aaMetricMd)
                    .foregroundStyle(stateColor)
                    .animation(.easeOut(duration: 0.15), value: postureState.displayName)

                Text(contextMessage)
                    .font(.aaBody)
                    .foregroundStyle(Color.aaSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        CurrentStateCard(
            postureState: .aligned,
            contextMessage: "Haptic feedback in 14s if neck angle stays below target."
        )
        CurrentStateCard(
            postureState: .slouching,
            contextMessage: "Adjust your posture to avoid a haptic cue."
        )
    }
    .padding()
    .background(Color.aaBackground)
}
