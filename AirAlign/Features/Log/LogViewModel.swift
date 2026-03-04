// LogViewModel.swift
// AirAlign — Features / Log

import Foundation
import SwiftData
import Observation

@Observable
final class LogViewModel {

    private(set) var totalSessions: Int = 0
    private(set) var totalHaptics: Int = 0
    private(set) var todayEvents: [PostureEvent] = []

    func load(sessions: [PostureSession], events: [PostureEvent]) {
        totalSessions = sessions.count
        totalHaptics = sessions.reduce(0) { $0 + $1.hapticCount }

        // Filter events from today across all sessions
        todayEvents = events
            .filter { Calendar.current.isDateInToday($0.timestamp) }
            .sorted { $0.timestamp < $1.timestamp }
    }
}
