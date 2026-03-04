// MainTabView.swift
// AirAlign — Core / Navigation

import SwiftUI
import SwiftData

/// Root navigation using Apple's native TabView.
/// Services are owned here so they live for the full app lifetime.
struct MainTabView: View {

    // Services — owned at the top level and passed to feature views
    @State private var motionManager = MotionManager()
    @State private var sessionManager = SessionManager()

    var body: some View {
        TabView {
            Tab("Live", systemImage: "waveform.path.ecg") {
                LiveView(
                    sessionManager: sessionManager,
                    motionManager: motionManager
                )
            }

            Tab("Stats", systemImage: "chart.bar.fill") {
                StatsView()
            }

            Tab("Log", systemImage: "list.bullet.rectangle") {
                LogView()
            }

            Tab("SetUp", systemImage: "slider.horizontal.3") {
                SetUpView(motionManager: motionManager)
            }
        }
        .tint(Color.aaMint)
    }
}

#Preview {
    MainTabView()
        .modelContainer(try! ModelContainerFactory.makePreviewContainer())
}
