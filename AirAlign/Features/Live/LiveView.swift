// LiveView.swift
// AirAlign — Features / Live

import SwiftUI
import SwiftData

struct LiveView: View {
    @Environment(\.modelContext) private var context
    @Query private var settingsQuery: [UserSettings]

    @State private var viewModel: LiveViewModel
    @State private var syncTimer: Timer?

    init(sessionManager: SessionManager, motionManager: MotionManager) {
        _viewModel = State(initialValue: LiveViewModel(
            sessionManager: sessionManager,
            motionManager: motionManager
        ))
    }

    private var settings: UserSettings? { settingsQuery.first }

    var body: some View {
        ZStack {
            Color.aaBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            SectionLabel(text: "Posture Session")
                            Text("Live")
                                .font(.aaTitle)
                                .foregroundStyle(Color.aaPrimary)
                        }
                        Spacer()
                        if viewModel.isSessionActive {
                            BadgePill(text: "Active")
                        } else {
                            BadgePill(text: "Idle", style: .outlined)
                        }
                    }

                    // Main Gauge
                    PostureGaugeCard(
                        scorePercent: viewModel.goodPosturePercent,
                        angleDegrees: viewModel.currentAngle,
                        angleFormatted: viewModel.angleFormatted
                    )

                    // Secondary cards
                    HStack(spacing: Spacing.md) {
                        TimeUprightCard(
                            formattedTime: viewModel.timeUprightFormatted,
                            barData: viewModel.uprightBarData
                        )
                        CurrentStateCard(
                            postureState: viewModel.postureState,
                            contextMessage: viewModel.postureState == .aligned
                                ? viewModel.hapticCountdownLabel
                                : viewModel.postureState.feedbackMessage
                        )
                    }

                    // Session CTA
                    if viewModel.isSessionActive {
                        PrimaryButton(title: "Stop Session") {
                            viewModel.stopSession(context: context)
                        }
                    } else {
                        PrimaryButton(title: "Start Session") {
                            guard let s = settings else { return }
                            viewModel.startSession(settings: s, context: context)
                        }
                    }

                    if !viewModel.isAirPodsConnected {
                        Label("Connect AirPods Pro to enable live monitoring.", systemImage: "airpodspro")
                            .font(.aaCaption)
                            .foregroundStyle(Color.aaSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.sm)
                .padding(.bottom, Spacing.xl)
            }
        }
        .onAppear {
            syncTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                viewModel.syncState()
            }
        }
        .onDisappear {
            syncTimer?.invalidate()
            syncTimer = nil
        }
        .task {
            // Ensure UserSettings singleton exists
            if settingsQuery.isEmpty {
                let default_ = UserSettings()
                context.insert(default_)
            }
        }
    }
}
