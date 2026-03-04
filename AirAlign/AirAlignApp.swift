// AirAlignApp.swift
// AirAlign — App Entry Point

import SwiftUI
import SwiftData

@main
struct AirAlignApp: App {

    private let container: ModelContainer = {
        do {
            return try ModelContainerFactory.makeProductionContainer()
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(container)
    }
}
