// ModelContainerFactory.swift
// AirAlign — Data / Persistence

import Foundation
import SwiftData

enum ModelContainerFactory {
    /// Full persistent schema used in production
    static var schema: Schema {
        Schema([
            PostureSession.self,
            PostureEvent.self,
            DailySummary.self,
            UserSettings.self,
        ])
    }

    /// On-disk production container
    static func makeProductionContainer() throws -> ModelContainer {
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [config])
    }

    /// In-memory container for SwiftUI Previews and unit tests
    static func makePreviewContainer() throws -> ModelContainer {
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
