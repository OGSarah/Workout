//
//  AccessibilityIdentifiers.swift
//  WorkoutUITests
//

import Foundation

/// A mirror of the app target's `AccessibilityIdentifiers`.
///
/// UI test targets cannot use `@testable import`, so this thin copy keeps the test queries readable
/// and in lock-step with the production identifiers. The values MUST match
/// `Workout/Code/Helpers/AccessibilityIdentifiers.swift` exactly.
enum AccessibilityIdentifiers {

    enum ExerciseList {
        static let list = "exerciseList"
        static let search = "exerciseSearch"
        static func row(_ exerciseID: String) -> String { "exerciseRow_\(exerciseID)" }
    }

    enum ExerciseDetail {
        static let timePeriodPicker = "timePeriodPicker"
        static let editGoalsButton = "editGoalsButton"
        static let goalGauges = "goalGauges"
        static let noGoalsState = "noGoalsState"
        static func chart(_ metric: String) -> String { "progressChart_\(metric)" }
    }

    enum EditGoals {
        static let weightField = "goalWeightField"
        static let repsField = "goalRepsField"
        static let durationField = "goalDurationField"
        static let saveButton = "saveGoalsButton"
        static let cancelButton = "cancelGoalsButton"
    }

    enum Root {
        static let loading = "loadingView"
        static let loadFailure = "loadFailureView"
    }
}
