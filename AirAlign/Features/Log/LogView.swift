// LogView.swift
// AirAlign — Features / Log

import SwiftUI
import SwiftData

struct LogView: View {
    @Query(sort: \PostureSession.startedAt, order: .reverse) private var sessions: [PostureSession]
    @Query(sort: \PostureEvent.timestamp, order: .reverse) private var allEvents: [PostureEvent]

    @State private var viewModel = LogViewModel()

    var body: some View {
        ZStack {
            Color.aaBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        SectionLabel(text: "Session History")
                        Text("Log")
                            .font(.aaTitle)
                            .foregroundStyle(Color.aaPrimary)
                    }

                    // Metrics row
                    HStack(spacing: Spacing.md) {
                        StatMetricCard(label: "Sessions", value: "\(viewModel.totalSessions)")
                        StatMetricCard(label: "Haptics", value: "\(viewModel.totalHaptics)")
                    }

                    // Today events
                    StatCard {
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            SectionLabel(text: "Today Events")

                            if viewModel.todayEvents.isEmpty {
                                Text("No events recorded today.")
                                    .font(.aaBody)
                                    .foregroundStyle(Color.aaTertiary)
                                    .padding(.vertical, Spacing.sm)
                            } else {
                                VStack(alignment: .leading, spacing: Spacing.md) {
                                    ForEach(viewModel.todayEvents) { event in
                                        EventRow(event: event)

                                        if event.id != viewModel.todayEvents.last?.id {
                                            Divider()
                                                .background(Color.aaCardBorder)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.sm)
                .padding(.bottom, Spacing.xl)
            }
        }
        .onChange(of: sessions) { _, s in viewModel.load(sessions: s, events: allEvents) }
        .onChange(of: allEvents) { _, e in viewModel.load(sessions: sessions, events: e) }
        .onAppear { viewModel.load(sessions: sessions, events: allEvents) }
    }
}
