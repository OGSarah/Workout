//
//  ExerciseDetailView.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import SwiftData
import SwiftUI

/// Shows a single exercise's goal gauges and progress charts, and lets the client edit goals.
struct ExerciseDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ExerciseDetailViewModel

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray.opacity(0.6), location: 0),
            Gradient.Stop(color: .gray.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(exercise: Exercise, setSummaries: [ExerciseSetSummary], now: Date = Date()) {
        _viewModel = State(initialValue: ExerciseDetailViewModel(exercise: exercise, setSummaries: setSummaries, now: now))
    }

    // MARK: - Main View
    var body: some View {
        @Bindable var viewModel = viewModel

        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            mainScrollView
        }
        .navigationTitle(viewModel.title)
        .task { viewModel.connect(to: GoalStore(context: modelContext)) }
        .sheet(isPresented: $viewModel.isEditingGoals) {
            EditExerciseGoalsSheet(viewModel: viewModel)
        }
    }

    // MARK: - Subviews
    private var mainScrollView: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                GoalGaugeSection(viewModel: viewModel)
                performanceOverTimeSection
                progressCharts
            }
            .padding(.horizontal)
        }
    }

    private var performanceOverTimeSection: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Performance Over Time", systemImage: "clock")
            timePeriodPicker
        }
    }

    private var timePeriodPicker: some View {
        @Bindable var viewModel = viewModel
        return Picker("Time Period", selection: $viewModel.timePeriod) {
            ForEach(TimePeriod.allCases) { period in
                Text(period.title).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityIdentifier(AccessibilityIdentifiers.ExerciseDetail.timePeriodPicker)
        .accessibilityLabel("Chart time period")
    }

    private var progressCharts: some View {
        VStack(spacing: 20) {
            ForEach(Self.chartConfigs, id: \.metric) { config in
                ProgressChart(
                    title: config.title,
                    points: viewModel.series(for: config.metric),
                    goal: viewModel.goalLine(for: config.metric),
                    period: viewModel.timePeriod,
                    axisDates: viewModel.axisDates,
                    style: config.style,
                    tint: config.tint,
                    goalUnit: config.goalUnit,
                    emptyMessage: config.emptyMessage,
                    emptySystemImage: config.emptySystemImage
                )
                .accessibilityIdentifier(AccessibilityIdentifiers.ExerciseDetail.chart(config.goalUnit))
                .padding(10)
                .glassCard()
            }
        }
    }

    /// Per-metric presentation for the three progress charts.
    private struct ChartConfig {
        let metric: ProgressMetric
        let title: String
        let style: ProgressChart.Style
        let tint: Color
        let goalUnit: String
        let emptyMessage: String
        let emptySystemImage: String
    }

    private static let chartConfigs: [ChartConfig] = [
        ChartConfig(
            metric: .weight, title: "Weight Progress (lbs)", style: .line, tint: .brightCoralRed,
            goalUnit: "lbs", emptyMessage: "No weight data for this time period.", emptySystemImage: "chart.xyaxis.line"
        ),
        ChartConfig(
            metric: .reps, title: "Reps Progress", style: .bar, tint: .yellow,
            goalUnit: "reps", emptyMessage: "No reps data for this time period.", emptySystemImage: "chart.bar.xaxis"
        ),
        ChartConfig(
            metric: .duration, title: "Duration Progress (min)", style: .line, tint: .brightLimeGreen,
            goalUnit: "min", emptyMessage: "No duration data for this time period.", emptySystemImage: "chart.xyaxis.line"
        )
    ]
}

// MARK: - Previews
#Preview("Light Mode") {
    NavigationStack {
        ExerciseDetailView(exercise: PreviewData.exercise, setSummaries: PreviewData.setSummaries)
    }
    .modelContainer(for: ExerciseGoal.self, inMemory: true)
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationStack {
        ExerciseDetailView(exercise: PreviewData.exercise, setSummaries: PreviewData.setSummaries)
    }
    .modelContainer(for: ExerciseGoal.self, inMemory: true)
    .preferredColorScheme(.dark)
}

#Preview("No Data") {
    NavigationStack {
        ExerciseDetailView(exercise: PreviewData.exercise, setSummaries: [])
    }
    .modelContainer(for: ExerciseGoal.self, inMemory: true)
}

#Preview("Accessibility XL") {
    NavigationStack {
        ExerciseDetailView(exercise: PreviewData.exercise, setSummaries: PreviewData.setSummaries)
    }
    .modelContainer(for: ExerciseGoal.self, inMemory: true)
    .dynamicTypeSize(.accessibility3)
}
