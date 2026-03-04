// PostureIcon.swift
// AirAlign — Design System / Components

import SwiftUI

/// Animated head + torso icon that visually reflects the current tilt angle.
/// Matches the PDF mockup: a dark circle (head) on a rectangular body (torso),
/// with the whole assembly rotated by the pitch angle.
struct PostureIcon: View {
    /// Tilt angle in degrees. Negative = forward tilt. Range: -45° to +45°.
    var angleDegrees: Double

    private var clampedAngle: Double {
        min(max(angleDegrees, -45), 45)
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Torso (rectangle)
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.aaMintMuted)
                .frame(width: 44, height: 52)
                .offset(y: 28)

            // Head (circle)
            Circle()
                .fill(Color.aaPrimary)
                .frame(width: 36, height: 36)
        }
        .rotationEffect(.degrees(clampedAngle), anchor: .bottom)
        .animation(.easeOut(duration: 0.15), value: clampedAngle)
        .frame(width: 60, height: 90)
    }
}

#Preview {
    HStack(spacing: Spacing.xl) {
        VStack {
            PostureIcon(angleDegrees: 0)
            Text("0°").font(.aaCaption)
        }
        VStack {
            PostureIcon(angleDegrees: -12)
            Text("-12°").font(.aaCaption)
        }
        VStack {
            PostureIcon(angleDegrees: -30)
            Text("-30°").font(.aaCaption)
        }
    }
    .padding()
    .background(Color.aaBackground)
}
