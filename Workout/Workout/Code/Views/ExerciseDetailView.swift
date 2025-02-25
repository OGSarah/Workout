//
//  ExerciseDetailView.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import SwiftUI

enum TimePeriod {
    case week, month, sixMonths, year
}

struct ExerciseDetailView: View {
    @State private var exercise: Exercise
    @State private var exerciseSetSummaries: [ExerciseSetSummary]
    @Environment(\.colorScheme) var colorScheme
    @State private var showEditSheet = false
    @State private var timePeriod: TimePeriod = .week

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray.opacity(0.6), location: 0),
            Gradient.Stop(color: .gray.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(
        exercise: Exercise,
        exerciseSetSummaries: [ExerciseSetSummary]
    ) {
        self._exercise = State(initialValue: exercise)
        self._exerciseSetSummaries = State(initialValue: exerciseSetSummaries)
    }

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                mainScrollView
            }
            .navigationTitle(exercise.name ?? "Empty Name")
        }
    }

    // MARK: - Subviews
    private var mainScrollView: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                goalGaugeSection
                performanceOverTimeSection
                progressCharts
            }
            .padding(.horizontal)
            .sheet(isPresented: $showEditSheet) {
                editGoalsSheet
            }
        }
    }

    private var goalGaugeSection: some View {
        GoalGaugeSection(
            exercise: $exercise,
            showEditSheet: $showEditSheet,
            exerciseSetSummaries: exerciseSetSummaries
        )
    }

    private var performanceOverTimeSection: some View {
        VStack(alignment: .leading) {
            performanceHeader
            timePeriodPicker
                .padding(.horizontal, -15)
        }
    }

    private var performanceHeader: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundStyle(.gray)
                .font(.subheadline)
                .padding(.trailing, -5)
            Text("PERFORMANCE OVER TIME")
                .foregroundStyle(.gray)
                .font(.subheadline)
        }
    }

    private var progressCharts: some View {
        VStack(spacing: 20) {
            weightProgressChart
            repsProgressChart
            durationProgressChart
        }
    }

    private var weightProgressChart: some View {
        WeightProgressChart(
            exerciseSetSummaries: exerciseSetSummaries,
            exerciseName: exercise.name ?? "No Exercise Name",
            timePeriod: timePeriod
        )
        .padding(.horizontal, 10)
        .padding(.top, 20)
        .background {
            glassBackground
                .padding(.top, -10)
        }
    }

    private var repsProgressChart: some View {
        RepsProgressChart(
            exerciseSetSummaries: exerciseSetSummaries,
            exerciseName: exercise.name ?? "No Exercise Name",
            timePeriod: timePeriod
        )
        .padding(.horizontal, 10)
        .padding(.top, 20)
        .background {
            glassBackground
        }
    }

    private var durationProgressChart: some View {
        DurationProgressChart(
            exerciseSetSummaries: exerciseSetSummaries,
            exerciseName: exercise.name ?? "No Exercise Name",
            timePeriod: timePeriod
        )
        .padding(.horizontal, 10)
        .padding(.top, 20)
        .background {
            glassBackground
        }
    }

    private var editGoalsSheet: some View {
        // Updated to match the new EditExerciseGoalsSheet requirements
        EditExerciseGoalsSheet(
            exercise: $exercise,
            showEditSheet: $showEditSheet,
            goalWeight: .constant(0),  // Temporary binding, actual values managed by GoalGaugeSection
            goalReps: .constant(0),
            goalDuration: .constant(0),
            onSave: {
                // Save action is handled by GoalGaugeSection
            }
        )
    }

    private var timePeriodPicker: some View {
        Picker("Time Period", selection: $timePeriod) {
            Text("Week").tag(TimePeriod.week)
            Text("Month").tag(TimePeriod.month)
            Text("6 Months").tag(TimePeriod.sixMonths)
            Text("Year").tag(TimePeriod.year)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black.opacity(0.1), lineWidth: 1)
                    .blur(radius: 1)
                    .mask(RoundedRectangle(cornerRadius: 15).fill(.black))
            }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Pushups")
    let sampleSummaries = [
        ExerciseSetSummary.sample(
            id: "1",
            exerciseSetID: "set1",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 2),
            completedAt: Date().addingTimeInterval(-86400 * 2),
            timeSpentActive: 60,
            weight: 20.0,
            repsReported: 10,
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise)
        ),
        ExerciseSetSummary.sample(
            id: "2",
            exerciseSetID: "set2",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400),
            completedAt: Date().addingTimeInterval(-86400),
            timeSpentActive: 60,
            weight: 25.0,
            repsReported: 12,
            exerciseSet: ExerciseSet.sample(id: "set2", exercise: sampleExercise)
        ),
        ExerciseSetSummary.sample(
            id: "3",
            exerciseSetID: "set3",
            workoutSummaryID: nil,
            startedAt: Date(),
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise)
        )
    ]

    return ExerciseDetailView(
        exercise: sampleExercise,
        exerciseSetSummaries: sampleSummaries
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Pushups")
    let sampleSummaries = [
        ExerciseSetSummary.sample(
            id: "1",
            exerciseSetID: "set1",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 2),
            completedAt: Date().addingTimeInterval(-86400 * 2),
            timeSpentActive: 60,
            weight: 20.0,
            repsReported: 10,
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise)
        ),
        ExerciseSetSummary.sample(
            id: "2",
            exerciseSetID: "set2",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400),
            completedAt: Date().addingTimeInterval(-86400),
            timeSpentActive: 60,
            weight: 25.0,
            repsReported: 12,
            exerciseSet: ExerciseSet.sample(id: "set2", exercise: sampleExercise)
        ),
        ExerciseSetSummary.sample(
            id: "3",
            exerciseSetID: "set3",
            workoutSummaryID: nil,
            startedAt: Date(),
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise)
        )
    ]

    return ExerciseDetailView(
        exercise: sampleExercise,
        exerciseSetSummaries: sampleSummaries
    )
    .preferredColorScheme(.dark)
}
