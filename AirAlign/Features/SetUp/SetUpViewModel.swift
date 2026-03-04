// SetUpViewModel.swift
// AirAlign — Features / SetUp

import Foundation
import SwiftData
import Observation

@Observable
final class SetUpViewModel {

    private(set) var calibrationState: CalibrationService.CalibrationState = .idle
    var settings: UserSettings?

    private let calibrationService = CalibrationService()

    // MARK: — Calibration

    func runCalibration(motionManager: MotionManager) {
        guard let settings else { return }
        calibrationService.start(motionManager: motionManager, settings: settings)
    }

    func cancelCalibration() {
        calibrationService.cancel()
    }

    func syncCalibrationState() {
        calibrationState = calibrationService.state
    }

    // MARK: — Settings Mutations

    func cycleSensitivity() {
        settings?.sensitivity = settings?.sensitivity.next ?? .medium
    }

    func toggleHaptics() {
        settings?.hapticsEnabled.toggle()
    }

    func toggleLiveActivity() {
        settings?.liveActivityEnabled.toggle()
    }

    // MARK: — Derived UI

    var calibrationProgress: Double {
        if case .capturing(let p) = calibrationState { return p }
        return 0
    }

    var isCalibrating: Bool {
        if case .capturing = calibrationState { return true }
        return false
    }

    var calibrationStatusLabel: String {
        switch calibrationState {
        case .idle:
            return settings?.calibrationDescription ?? "Not calibrated yet."
        case .capturing(let p):
            return "Capturing… \(Int(p * 100))%"
        case .complete:
            return "Calibration complete ✓"
        case .failed(let reason):
            return "Failed: \(reason)"
        }
    }

    var liveActivityStatusLabel: String {
        guard settings?.liveActivityEnabled == true else { return "Ready" }
        return LiveActivityManager.shared.isActive ? "Active" : "Ready"
    }
}
