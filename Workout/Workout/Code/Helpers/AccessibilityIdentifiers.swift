//
//  AccessibilityIdentifiers.swift
//  Workout
//

import Foundation

/// The single source of truth for accessibility identifiers used to drive UI tests.
///
/// Views reference these constants instead of inline string literals so an identifier can never
/// drift out of sync with the test that looks it up. The UI test target keeps a small mirror of
/// these values (it cannot `@testable import` the app), so the two are deliberately kept identical.
enum AccessibilityIdentifiers {

    /// The root exercise list screen.
    enum ExerciseList {
        static let list = "exerciseList"
        static let search = "exerciseSearch"
        static func row(_ exerciseID: String) -> String { "exerciseRow_\(exerciseID)" }
    }

    /// The per-exercise detail screen with gauges and charts.
    enum ExerciseDetail {
        static let timePeriodPicker = "timePeriodPicker"
        static let editGoalsButton = "editGoalsButton"
        static let goalGauges = "goalGauges"
        static let noGoalsState = "noGoalsState"
        static func chart(_ metric: String) -> String { "progressChart_\(metric)" }
    }

    /// The goal-editing sheet.
    enum EditGoals {
        static let weightField = "goalWeightField"
        static let repsField = "goalRepsField"
        static let durationField = "goalDurationField"
        static let saveButton = "saveGoalsButton"
        static let cancelButton = "cancelGoalsButton"
    }

    /// The app's root load states.
    enum Root {
        static let loading = "loadingView"
        static let loadFailure = "loadFailureView"
    }
}
