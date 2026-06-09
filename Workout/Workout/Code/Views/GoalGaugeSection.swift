//
//  GoalGaugeSection.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

/// The "Performance Goals" section: a gauge per set goal showing progress toward it, or a prompt to
/// add goals when none exist. All values and persistence live in the view model.
struct GoalGaugeSection: View {
    @Bindable var viewModel: ExerciseDetailViewModel

    private let weightGradient = Gradient(colors: [.lightPink, .brightCoralRed, .pink])
    private let repsGradient = Gradient(colors: [.lightYellow, .yellow, .darkYellow])
    private let durationGradient = Gradient(colors: [.lightGreen, .brightLimeGreen, .green])

    // MARK: - Main View
    var body: some View {
        VStack(spacing: 16) {
            header
            if viewModel.hasGoals {
                gauges
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .glassCard()
                    .accessibilityIdentifier(AccessibilityIdentifiers.ExerciseDetail.goalGauges)
            } else {
                ContentUnavailableView(
                    "No Goals Set",
                    systemImage: "target",
                    description: Text("Set some performance goals to track your progress!")
                )
                .padding()
                .glassCard()
                .accessibilityIdentifier(AccessibilityIdentifiers.ExerciseDetail.noGoalsState)
            }
        }
    }

    // MARK: - Subviews
    private var header: some View {
        HStack {
            SectionHeader(title: "Performance Goals", systemImage: "figure.strengthtraining.traditional")
            Button(viewModel.hasGoals ? "Edit Goals" : "Add Goals") {
                viewModel.startEditingGoals()
            }
            .buttonStyle(.glass)
            .accessibilityIdentifier(AccessibilityIdentifiers.ExerciseDetail.editGoalsButton)
            .accessibilityHint("Opens the goal editor for this exercise")
        }
    }

    private var gauges: some View {
        HStack(spacing: 40) {
            if viewModel.goalWeight > 0 {
                gauge(
                    title: "Weight (lbs)",
                    value: viewModel.currentMaxWeight,
                    goal: viewModel.goalWeight,
                    percent: viewModel.weightProgress,
                    gradient: weightGradient
                )
            }
            if viewModel.goalReps > 0 {
                gauge(
                    title: "Reps",
                    value: viewModel.currentMaxReps,
                    goal: Double(viewModel.goalReps),
                    percent: viewModel.repsProgress,
                    gradient: repsGradient
                )
            }
            if viewModel.goalDuration > 0 {
                gauge(
                    title: "Duration (min)",
                    value: viewModel.currentMaxDuration,
                    goal: Double(viewModel.goalDuration),
                    percent: viewModel.durationProgress,
                    gradient: durationGradient
                )
            }
        }
    }

    private func gauge(title: String, value: Double, goal: Double, percent: Int, gradient: Gradient) -> some View {
        VStack(spacing: 10) {
            Gauge(value: value, in: 0...goal) {
                EmptyView()
            } currentValueLabel: {
                Text("\(percent)%")
                    .font(.headline)
            } minimumValueLabel: {
                Text("0")
                    .font(.caption2)
            } maximumValueLabel: {
                Text("\(Int(goal))")
                    .font(.caption2)
            }
            .gaugeStyle(.accessoryCircular)
            .tint(gradient)
            .scaleEffect(1.5)

            Text(title)
                .font(.callout)
                .foregroundStyle(.gray)
                .padding(.top, 10)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title) goal")
        .accessibilityValue("\(Int(value)) of \(Int(goal)), \(percent) percent complete")
    }
}

// MARK: - Previews
#Preview("With Goals") {
    GoalGaugeSection(viewModel: PreviewData.detailViewModel(withGoals: true))
        .padding()
}

#Preview("No Goals") {
    GoalGaugeSection(viewModel: PreviewData.detailViewModel(withGoals: false))
        .padding()
}

#Preview("Accessibility XL") {
    GoalGaugeSection(viewModel: PreviewData.detailViewModel(withGoals: true))
        .padding()
        .dynamicTypeSize(.accessibility2)
}
