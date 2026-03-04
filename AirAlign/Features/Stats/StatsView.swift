// StatsView.swift
// AirAlign — Features / Stats

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query(sort: \DailySummary.date, order: .reverse) private var summaries: [DailySummary]
    @Query(sort: \PostureSession.startedAt, order: .reverse) private var sessions: [PostureSession]

    @State private var viewModel = StatsViewModel()

    var body: some View {
        ZStack {
            Color.aaBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        SectionLabel(text: "Weekly Analytics")
                        Text("Stats")
                            .font(.aaTitle)
                            .foregroundStyle(Color.aaPrimary)
                    }

                    // Weekly chart
                    WeeklyChartCard(
                        scorePercent: viewModel.weeklyScorePercent,
                        sessionCount: viewModel.weeklySessionCount,
                        bars: viewModel.chartData
                    )

                    // Session + haptics summary
                    SessionSummaryCard(
                        session: viewModel.featuredSession,
                        hapticCount: viewModel.weeklyAlertCount
                    )

                    // Daily breakdown
                    DailyBreakdownCard(rows: viewModel.dailyBreakdown)
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.sm)
                .padding(.bottom, Spacing.xl)
            }
        }
        .onChange(of: summaries) { _, new in viewModel.load(summaries: new, sessions: sessions) }
        .onChange(of: sessions) { _, new in viewModel.load(summaries: summaries, sessions: new) }
        .onAppear { viewModel.load(summaries: summaries, sessions: sessions) }
    }
}
