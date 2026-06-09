//
//  ExerciseDetailViewModel.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import Foundation
import Observation

/// Drives the exercise detail screen: goal gauges, the time-period charts, and goal editing.
///
/// All progress math is delegated to the pure logic in `Domain/Logic`, and goal persistence is
/// handled by an injected ``GoalStore`` so this type stays free of SwiftData and `Date()` details.
@MainActor
@Observable
final class ExerciseDetailViewModel {
    let exercise: Exercise

    var timePeriod: TimePeriod = .week

    /// The currently saved goals.
    private(set) var goalWeight: Double = 0
    private(set) var goalReps: Int = 0
    private(set) var goalDuration: Int = 0

    /// Draft values bound to the edit sheet.
    var draftWeight: Double = 0
    var draftReps: Int = 0
    var draftDuration: Int = 0
    var isEditingGoals = false

    private let setSummaries: [ExerciseSetSummary]
    private let now: Date
    private var goalStore: (any GoalStoreProtocol)?

    init(exercise: Exercise, setSummaries: [ExerciseSetSummary], now: Date = Date()) {
        self.exercise = exercise
        self.setSummaries = setSummaries
        self.now = now
    }

    // MARK: - Display

    var title: String { exercise.name ?? "Exercise" }

    var hasGoals: Bool { goalWeight > 0 || goalReps > 0 || goalDuration > 0 }

    var currentMaxWeight: Double { maxValue(of: .weight) }
    var currentMaxReps: Double { maxValue(of: .reps) }
    var currentMaxDuration: Double { maxValue(of: .duration) }

    var weightProgress: Int { GoalProgress.percent(current: currentMaxWeight, goal: goalWeight) }
    var repsProgress: Int { GoalProgress.percent(current: currentMaxReps, goal: Double(goalReps)) }
    var durationProgress: Int { GoalProgress.percent(current: currentMaxDuration, goal: Double(goalDuration)) }

    /// The chart series for a metric in the selected time period.
    func series(for metric: ProgressMetric) -> [ChartPoint] {
        ChartData.series(from: setSummaries, exerciseID: exercise.id, metric: metric, period: timePeriod, now: now)
    }

    /// The goal value to draw as a reference line for a metric, if one is set.
    func goalLine(for metric: ProgressMetric) -> Double? {
        let value: Double
        switch metric {
        case .weight: value = goalWeight
        case .reps: value = Double(goalReps)
        case .duration: value = Double(goalDuration)
        }
        return value > 0 ? value : nil
    }

    /// The dates used for the chart X-axis tick marks in the selected time period.
    var axisDates: [Date] {
        TimeWindow.axisDates(for: timePeriod, now: now)
    }

    // MARK: - Goals

    /// Connects the view model to persistence and loads any saved goals.
    func connect(to goalStore: any GoalStoreProtocol) {
        self.goalStore = goalStore
        loadGoals()
    }

    func startEditingGoals() {
        draftWeight = goalWeight
        draftReps = goalReps
        draftDuration = goalDuration
        isEditingGoals = true
    }

    func cancelEditingGoals() {
        isEditingGoals = false
    }

    func saveGoals() {
        goalStore?.upsert(exerciseID: exercise.id, weight: draftWeight, reps: draftReps, duration: draftDuration)
        loadGoals()
        isEditingGoals = false
    }

    private func loadGoals() {
        guard let goal = goalStore?.goal(forExerciseID: exercise.id) else {
            goalWeight = 0
            goalReps = 0
            goalDuration = 0
            return
        }
        goalWeight = goal.weight
        goalReps = goal.reps
        goalDuration = goal.duration
    }

    private func maxValue(of metric: ProgressMetric) -> Double {
        ExerciseAggregation.maxValue(of: metric, forExerciseID: exercise.id, in: setSummaries) ?? 0
    }
}
