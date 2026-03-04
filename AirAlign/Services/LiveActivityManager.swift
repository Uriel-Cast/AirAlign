// LiveActivityManager.swift
// AirAlign — Services

import Foundation

/// Stub for ActivityKit / Live Activity integration.
/// Requires the com.apple.developer.live-activity entitlement to be active.
/// Currently provides only a ready-state flag and placeholder API.
final class LiveActivityManager {

    static let shared = LiveActivityManager()

    private(set) var isSupported: Bool = false
    private(set) var isActive: Bool = false

    private init() {
        // ActivityKit is available on iOS 16.1+
        // Actual implementation requires ActivityKit import + project entitlement
        if #available(iOS 16.1, *) {
            isSupported = true
        }
    }

    /// Start a Live Activity showing current posture state
    func start(postureState: PostureState, score: Double) {
        guard isSupported else { return }
        // TODO: Implement with ActivityKit when entitlement is active
        // Example:
        // let attributes = PostureActivityAttributes(sessionStart: Date())
        // let state = PostureActivityAttributes.ContentState(postureState: postureState, score: score)
        // let content = ActivityContent(state: state, staleDate: nil)
        // activity = try? Activity<PostureActivityAttributes>.request(attributes: attributes, content: content)
        isActive = true
    }

    /// Update the Live Activity with new posture data
    func update(postureState: PostureState, score: Double) {
        guard isSupported, isActive else { return }
        // TODO: activity?.update(...)
    }

    /// End the Live Activity
    func stop() {
        guard isActive else { return }
        // TODO: await activity?.end(...)
        isActive = false
    }
}
