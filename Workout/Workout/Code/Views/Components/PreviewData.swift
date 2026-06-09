//
//  PreviewData.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

#if DEBUG
import Foundation
import SwiftData

/// Sample data used only by SwiftUI previews.
enum PreviewData {

    static let exercise = Exercise.sample(id: "ex1", name: "Bicep Curl")

    static let exercises: [Exercise] = [
        Exercise.sample(id: "ex1", name: "Bicep Curl"),
        Exercise.sample(id: "ex2", name: "Bench Press"),
        Exercise.sample(id: "ex3", name: "Squat")
    ]

    /// A short, improving streak of sets over the past week so the gauges and charts have data.
    static let setSummaries: [ExerciseSetSummary] = {
        let calendar = Calendar.current
        let now = Date()
        let samples: [(daysAgo: Int, weight: Double, reps: Int, duration: Int)] = [
            (5, 20, 10, 45), (4, 22, 11, 50), (3, 25, 12, 55), (2, 27, 13, 60), (1, 30, 14, 62), (0, 32, 15, 65)
        ]
        return samples.compactMap { sample in
            guard let date = calendar.date(byAdding: .day, value: -sample.daysAgo, to: now) else { return nil }
            return makeSummary(on: date, weight: sample.weight, reps: sample.reps, duration: sample.duration)
        }
    }()

    /// A detail view model for the sample exercise, optionally seeded with goals via an in-memory store.
    @MainActor
    static func detailViewModel(withGoals: Bool) -> ExerciseDetailViewModel {
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: setSummaries)
        if withGoals {
            // swiftlint:disable:next force_try
            let container = try! ModelContainer(for: ExerciseGoal.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            let store = GoalStore(context: ModelContext(container))
            store.upsert(exerciseID: exercise.id, weight: 40, reps: 20, duration: 70)
            viewModel.connect(to: store)
        }
        return viewModel
    }

    private static func makeSummary(on date: Date, weight: Double, reps: Int, duration: Int) -> ExerciseSetSummary? {
        let iso = ISO8601DateFormatter().string(from: date)
        let json = """
        {
            "set_id": "s", "started_at": "\(iso)", "completed_at": "\(iso)",
            "time_spent_active": \(duration), "reps_reported": \(reps),
            "set": {
                "id": "s", "weight": \(weight), "reps": \(reps), "duration": \(duration),
                "exercise": { "id": "ex1", "name": "Bicep Curl" }
            }
        }
        """
        return try? JSONDecoder().decode(ExerciseSetSummary.self, from: Data(json.utf8))
    }
}
#endif
