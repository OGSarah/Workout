//
//  ExerciseAggregationTests.swift
//  WorkoutTests
//

import Testing
@testable import Workout

struct ExerciseAggregationTests {

    @Test func deduplicatesByNameAndSortsAlphabetically() throws {
        let summary = try TestSupport.workoutSummary(withExercises: [
            (id: "1", name: "Squat"),
            (id: "2", name: "Bench Press"),
            (id: "3", name: "Squat") // duplicate name
        ])

        let exercises = ExerciseAggregation.extractExercises(from: [summary])

        #expect(exercises.map(\.name) == ["Bench Press", "Squat"])
    }

    @Test func keepsUnnamedExercisesAndSortsThemLast() throws {
        let summary = try TestSupport.workoutSummary(withExercises: [
            (id: "1", name: nil),
            (id: "2", name: "Plank")
        ])

        let exercises = ExerciseAggregation.extractExercises(from: [summary])

        #expect(exercises.count == 2)
        #expect(exercises.first?.name == "Plank")
        #expect(exercises.last?.name == nil)
    }

    @Test func maxValueFiltersByExerciseID() {
        let squat = Exercise.sample(id: "squat", name: "Squat")
        let bench = Exercise.sample(id: "bench", name: "Bench Press")
        let date = TestSupport.date(2026, 2, 15)

        let summaries = [
            TestSupport.setSummary(on: date, exercise: squat, weight: 50),
            TestSupport.setSummary(on: date, exercise: squat, weight: 60),
            TestSupport.setSummary(on: date, exercise: bench, weight: 200) // different exercise, must be ignored
        ]

        let maxSquat = ExerciseAggregation.maxValue(of: .weight, forExerciseID: "squat", in: summaries)
        #expect(maxSquat == 60)
    }

    @Test func maxValueReturnsNilWhenNoData() {
        let squat = Exercise.sample(id: "squat", name: "Squat")
        let summaries = [TestSupport.setSummary(on: TestSupport.date(2026, 2, 15), exercise: squat, reps: 10)]
        // No weight recorded for any squat set.
        #expect(ExerciseAggregation.maxValue(of: .weight, forExerciseID: "squat", in: summaries) == nil)
    }
}
