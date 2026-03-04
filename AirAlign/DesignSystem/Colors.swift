// Colors.swift
// AirAlign — Design System
// Uses UIColor dynamic providers so every color adapts automatically
// to the system appearance (light / dark) without any @Environment needed.

import SwiftUI
import UIKit

// MARK: — Dynamic Color Helper

private func adaptive(light: UIColor, dark: UIColor) -> Color {
    Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? dark : light
    })
}

// MARK: — AirAlign Color Palette

extension Color {

    // ─── Accent ────────────────────────────────────────────────────────────────
    /// Primary mint-green — active states, badges, CTAs, chart highlights
    static let aaMint = adaptive(
        light: UIColor(red: 0.25, green: 0.78, blue: 0.52, alpha: 1),
        dark:  UIColor(red: 0.20, green: 0.72, blue: 0.48, alpha: 1)
    )
    /// Muted mint — chart bars, inactive elements
    static let aaMintMuted = adaptive(
        light: UIColor(red: 0.58, green: 0.84, blue: 0.70, alpha: 1),
        dark:  UIColor(red: 0.30, green: 0.55, blue: 0.42, alpha: 1)
    )
    /// Very light mint — subtle fills, icon backgrounds
    static let aaMintSubtle = adaptive(
        light: UIColor(red: 0.87, green: 0.96, blue: 0.91, alpha: 1),
        dark:  UIColor(red: 0.10, green: 0.22, blue: 0.16, alpha: 1)
    )

    // ─── Backgrounds ───────────────────────────────────────────────────────────
    /// App-wide background
    static let aaBackground = adaptive(
        light: UIColor(red: 0.91, green: 0.94, blue: 0.92, alpha: 1),
        dark:  UIColor(red: 0.06, green: 0.10, blue: 0.08, alpha: 1)
    )
    /// Card surface
    static let aaCard = adaptive(
        light: UIColor(red: 0.93, green: 0.96, blue: 0.94, alpha: 1),
        dark:  UIColor(red: 0.10, green: 0.15, blue: 0.12, alpha: 1)
    )
    /// Card border / separator
    static let aaCardBorder = adaptive(
        light: UIColor(red: 0.78, green: 0.88, blue: 0.82, alpha: 1),
        dark:  UIColor(red: 0.18, green: 0.26, blue: 0.21, alpha: 1)
    )

    // ─── Text ──────────────────────────────────────────────────────────────────
    /// Primary text — near-black in light, near-white in dark
    static let aaPrimary = adaptive(
        light: UIColor(red: 0.08, green: 0.22, blue: 0.14, alpha: 1),
        dark:  UIColor(red: 0.88, green: 0.95, blue: 0.91, alpha: 1)
    )
    /// Secondary label — muted sage
    static let aaSecondary = adaptive(
        light: UIColor(red: 0.36, green: 0.55, blue: 0.44, alpha: 1),
        dark:  UIColor(red: 0.50, green: 0.68, blue: 0.57, alpha: 1)
    )
    /// Tertiary / caption
    static let aaTertiary = adaptive(
        light: UIColor(red: 0.54, green: 0.68, blue: 0.59, alpha: 1),
        dark:  UIColor(red: 0.32, green: 0.46, blue: 0.38, alpha: 1)
    )

    // ─── Semantic ──────────────────────────────────────────────────────────────
    static let aaPositive    = Color.aaMint
    static let aaWarning     = adaptive(
        light: UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1),
        dark:  UIColor(red: 1.00, green: 0.75, blue: 0.20, alpha: 1)
    )
    static let aaDestructive = adaptive(
        light: UIColor(red: 0.90, green: 0.30, blue: 0.30, alpha: 1),
        dark:  UIColor(red: 1.00, green: 0.40, blue: 0.40, alpha: 1)
    )
}
