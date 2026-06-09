//
//  WorkoutUITests.swift
//  WorkoutUITests
//
//  Created by Sarah Clark on 2/19/25.
//

import XCTest

final class WorkoutUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // `--uitesting` swaps the persistent goal store for an in-memory one so each run starts clean.
        app.launchArguments += ["--uitesting"]
        app.launch()
    }

    /// Launches the app, opens an exercise, adds a goal, and confirms the gauges replace the
    /// "No Goals Set" empty state.
    @MainActor
    func testAddingGoalShowsGauges() throws {
        openFirstExercise()

        // The detail screen starts with no goals set.
        XCTAssertTrue(app.staticTexts["No Goals Set"].waitForExistence(timeout: 5))

        // Open the goal editor and set a weight goal.
        app.buttons[AccessibilityIdentifiers.ExerciseDetail.editGoalsButton].tap()

        let weightField = app.textFields[AccessibilityIdentifiers.EditGoals.weightField]
        XCTAssertTrue(weightField.waitForExistence(timeout: 5))
        weightField.tap()
        weightField.typeText("100")

        app.buttons[AccessibilityIdentifiers.EditGoals.saveButton].tap()

        // After saving, the gauges replace the empty state and the button offers to edit.
        XCTAssertTrue(app.buttons["Edit Goals"].waitForExistence(timeout: 5), "Button should switch to Edit Goals")
        XCTAssertFalse(app.staticTexts["No Goals Set"].exists, "Empty state should be gone")
    }

    /// Cancelling the goal editor leaves the empty state untouched.
    @MainActor
    func testCancellingGoalEditingKeepsEmptyState() throws {
        openFirstExercise()
        XCTAssertTrue(app.staticTexts["No Goals Set"].waitForExistence(timeout: 5))

        app.buttons[AccessibilityIdentifiers.ExerciseDetail.editGoalsButton].tap()
        let weightField = app.textFields[AccessibilityIdentifiers.EditGoals.weightField]
        XCTAssertTrue(weightField.waitForExistence(timeout: 5))
        weightField.tap()
        weightField.typeText("100")

        app.buttons[AccessibilityIdentifiers.EditGoals.cancelButton].tap()

        XCTAssertTrue(app.staticTexts["No Goals Set"].waitForExistence(timeout: 5), "Empty state should remain")
    }

    /// Searching narrows the list and clearing the query restores it.
    @MainActor
    func testSearchFiltersExerciseList() throws {
        let list = app.collectionViews[AccessibilityIdentifiers.ExerciseList.list]
        XCTAssertTrue(list.waitForExistence(timeout: 15), "Exercise list should load")
        XCTAssertGreaterThan(list.cells.count, 0, "There should be exercises to begin with")

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("zzzzzzzz")

        XCTAssertEqual(list.cells.count, 0, "No exercise should match an impossible query")

        // Clearing the query brings the full list back.
        if app.buttons["Clear text"].exists {
            app.buttons["Clear text"].tap()
        } else {
            searchField.buttons.firstMatch.tap()
        }
        XCTAssertGreaterThan(list.cells.count, 0, "Clearing search should restore the list")
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    // MARK: - Helpers

    private func openFirstExercise() {
        let list = app.collectionViews[AccessibilityIdentifiers.ExerciseList.list]
        XCTAssertTrue(list.waitForExistence(timeout: 15), "Exercise list should load")

        let firstExercise = list.buttons.firstMatch
        XCTAssertTrue(firstExercise.waitForExistence(timeout: 10), "There should be at least one exercise")
        firstExercise.tap()
    }
}
