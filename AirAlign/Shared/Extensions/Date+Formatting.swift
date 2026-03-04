// Date+Formatting.swift
// AirAlign — Shared / Extensions

import Foundation

extension Date {
    /// "HH:mm" — used in event timeline
    var shortTime: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm"
        return fmt.string(from: self)
    }

    /// "EEEE" — "Monday", "Tuesday", etc.
    var weekdayName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEEE"
        return fmt.string(from: self)
    }

    /// Normalizes to midnight for DailySummary keying
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
