// CalibrationService.swift
// AirAlign — Services

import Foundation
import Observation

/// Captures a rolling average of the head pitch over a short window
/// and writes the resulting baseline to UserSettings.
@Observable
final class CalibrationService {

    enum CalibrationState {
        case idle
        case capturing(progress: Double)   // 0.0 – 1.0
        case complete(baselineAngle: Double)
        case failed(reason: String)
    }

    private(set) var state: CalibrationState = .idle

    private let captureDuration: TimeInterval = 8.0   // seconds (from PDF: "8 seconds of neutral posture")
    private var samples: [Double] = []
    private var startTime: Date?
    private var captureTimer: Timer?

    // MARK: — API

    /// Begin collecting pitch samples from `motionManager`.
    /// Call `stop()` to cancel early; completion is automatic after `captureDuration`.
    func start(motionManager: MotionManager, settings: UserSettings) {
        guard case .idle = state else { return }

        samples = []
        startTime = Date()
        state = .capturing(progress: 0)

        captureTimer = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { [weak self] _ in
            guard let self else { return }
            self.tick(motionManager: motionManager, settings: settings)
        }
    }

    func cancel() {
        captureTimer?.invalidate()
        captureTimer = nil
        state = .idle
    }

    // MARK: — Private

    private func tick(motionManager: MotionManager, settings: UserSettings) {
        let elapsed = Date().timeIntervalSince(startTime ?? Date())
        let progress = min(elapsed / captureDuration, 1.0)

        samples.append(motionManager.currentPitch)
        state = .capturing(progress: progress)

        if elapsed >= captureDuration {
            captureTimer?.invalidate()
            captureTimer = nil
            finalise(settings: settings)
        }
    }

    private func finalise(settings: UserSettings) {
        guard !samples.isEmpty else {
            state = .failed(reason: "No motion data received.")
            return
        }
        let average = samples.reduce(0, +) / Double(samples.count)
        settings.baselineAngle = average
        settings.calibratedAt = Date()
        state = .complete(baselineAngle: average)
    }
}
