// MotionManager.swift
// AirAlign — Services

import Foundation
import CoreMotion
import Observation

/// Wraps `CMHeadphoneMotionManager` and publishes the current head pitch angle.
/// On Simulator (where AirPods are unavailable) it falls back to `simulatedAngle`.
@Observable
final class MotionManager {
    // MARK: — Published State
    private(set) var currentPitch: Double = 0      // degrees, negative = forward tilt
    private(set) var isAvailable: Bool = false
    private(set) var isActive: Bool = false

    // MARK: — Simulation (Previews / Simulator)
    var simulatedAngle: Double = 0 {
        didSet { if isSimulating { currentPitch = simulatedAngle } }
    }
    private(set) var isSimulating: Bool = false

    // MARK: — Private
    private let manager = CMHeadphoneMotionManager()
    private let queue = OperationQueue()

    // MARK: — Lifecycle

    func start() {
        guard manager.isDeviceMotionAvailable else {
            isSimulating = true
            isAvailable = false
            currentPitch = simulatedAngle
            return
        }

        isAvailable = true
        isSimulating = false

        manager.startDeviceMotionUpdates(to: queue) { [weak self] motion, error in
            guard let self, let motion, error == nil else { return }
            // pitch: rotation around the x-axis; convert radians → degrees
            let degrees = motion.attitude.pitch * (180 / .pi)
            DispatchQueue.main.async {
                self.currentPitch = degrees
                self.isActive = true
            }
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
        isActive = false
    }

    deinit { stop() }
}
