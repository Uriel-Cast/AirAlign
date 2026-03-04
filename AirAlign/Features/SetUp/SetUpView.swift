// SetUpView.swift
// AirAlign — Features / SetUp

import SwiftUI
import SwiftData
internal import Combine

struct SetUpView: View {
    @Environment(\.modelContext) private var context
    @Query private var settingsQuery: [UserSettings]

    @State private var viewModel = SetUpViewModel()

    private let motionManager: MotionManager

    init(motionManager: MotionManager) {
        self.motionManager = motionManager
    }

    private var settings: UserSettings? { settingsQuery.first }

    var body: some View {
        ZStack {
            Color.aaBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        SectionLabel(text: "Calibration & Feedback")
                        Text("SetUp")
                            .font(.aaTitle)
                            .foregroundStyle(Color.aaPrimary)
                    }

                    // Calibration
                    CalibrationCard(
                        statusLabel: viewModel.calibrationStatusLabel,
                        isCalibrating: viewModel.isCalibrating,
                        progress: viewModel.calibrationProgress
                    ) {
                        viewModel.runCalibration(motionManager: motionManager)
                    }

                    // Sensitivity
                    SensitivityRow(
                        level: settings?.sensitivity ?? .medium
                    ) {
                        viewModel.cycleSensitivity()
                    }

                    // Haptics
                    HapticsRow(
                        isEnabled: settings?.hapticsEnabled ?? true
                    ) {
                        viewModel.toggleHaptics()
                    }

                    // Live Activity
                    LiveActivityRow(
                        statusLabel: viewModel.liveActivityStatusLabel,
                        isEnabled: settings?.liveActivityEnabled ?? false
                    ) {
                        viewModel.toggleLiveActivity()
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.sm)
                .padding(.bottom, Spacing.xl)
            }
        }
        .onAppear {
            viewModel.settings = settings
            if settingsQuery.isEmpty {
                let s = UserSettings()
                context.insert(s)
                viewModel.settings = s
            }
        }
        .onChange(of: settingsQuery) { _, new in
            viewModel.settings = new.first
        }
        .onReceive(Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()) { _ in
            viewModel.syncCalibrationState()
        }
    }
}
