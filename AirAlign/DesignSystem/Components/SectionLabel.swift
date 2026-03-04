// SectionLabel.swift
// AirAlign — Design System / Components

import SwiftUI

/// ALL-CAPS, tracked, muted-green label used as section headers
/// (e.g. "POSTURE SESSION", "WEEKLY ANALYTICS", "TODAY EVENTS")
struct SectionLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .sectionCaption()
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.sm) {
        SectionLabel(text: "Posture Session")
        SectionLabel(text: "Weekly Analytics")
        SectionLabel(text: "Today Events")
    }
    .padding()
    .background(Color.aaBackground)
}
