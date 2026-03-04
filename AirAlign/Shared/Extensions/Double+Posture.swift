// Double+Posture.swift
// AirAlign — Shared / Extensions

import Foundation

extension Double {
    /// Converts raw pitch radians to display-ready degrees string  e.g. "-12°"
    var tiltDegrees: Double { self * (180 / .pi) }

    /// Clips to the safe icon rotation range
    var clampedTiltAngle: Double { min(max(self, -45), 45) }
}
