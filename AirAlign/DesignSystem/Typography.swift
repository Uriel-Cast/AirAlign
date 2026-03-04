// Typography.swift
// AirAlign — Design System

import SwiftUI

extension Font {
    // MARK: — Display / Hero numbers (e.g. 87%, 4H 12M)
    static let aaDisplay    = Font.system(size: 64, weight: .bold, design: .default)
    static let aaDisplayMd  = Font.system(size: 48, weight: .bold, design: .default)

    // MARK: — Monospace metrics (percentages, times, angles)
    static let aaMetricLg   = Font.system(size: 40, weight: .bold, design: .monospaced)
    static let aaMetricMd   = Font.system(size: 28, weight: .bold, design: .monospaced)
    static let aaMetricSm   = Font.system(size: 20, weight: .semibold, design: .monospaced)

    // MARK: — Event / log entries (monospace body)
    static let aaLogTitle   = Font.system(size: 15, weight: .bold, design: .monospaced)
    static let aaLogBody    = Font.system(size: 14, weight: .regular, design: .default)

    // MARK: — Section labels (ALL CAPS, tracked)
    static let aaCaptionUp  = Font.system(size: 11, weight: .semibold, design: .default)

    // MARK: — UI labels
    static let aaTitle      = Font.system(size: 34, weight: .bold, design: .default)
    static let aaHeadline   = Font.system(size: 17, weight: .semibold, design: .default)
    static let aaBody       = Font.system(size: 15, weight: .regular, design: .default)
    static let aaCaption    = Font.system(size: 12, weight: .regular, design: .default)

    // MARK: — Tab bar labels
    static let aaTabLabel   = Font.system(size: 10, weight: .semibold, design: .default)
}

// MARK: — ViewModifier: Upper-tracked caption style
struct SectionCaptionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.aaCaptionUp)
            .tracking(2.0)
            .textCase(.uppercase)
            .foregroundStyle(Color.aaSecondary)
    }
}

extension View {
    func sectionCaption() -> some View {
        modifier(SectionCaptionStyle())
    }
}
