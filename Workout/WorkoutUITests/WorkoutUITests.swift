//
//  WorkoutUITests.swift
//  WorkoutUITests
//
//  Created by Sarah Clark on 2/19/25.
//

import XCTest

final class WorkoutUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Launches the app, opens an exercise, adds a goal, and confirms the gauges replace the
    /// "No Goals Set" empty state.
    @MainActor
    func testAddingGoalShowsGauges() throws {
        let app = XCUIApplication()
        app.launchArguments += ["--uitesting"]
        app.launch()

        // The exercise list loads with rows.
        let list = app.collectionViews["exerciseList"]
        XCTAssertTrue(list.waitForExistence(timeout: 15), "Exercise list should load")

        let firstExercise = list.buttons.firstMatch
        XCTAssertTrue(firstExercise.waitForExistence(timeout: 10), "There should be at least one exercise")
        firstExercise.tap()

        // The detail screen starts with no goals set.
        XCTAssertTrue(app.staticTexts["No Goals Set"].waitForExistence(timeout: 5))

        // Open the goal editor and set a weight goal.
        app.buttons["editGoalsButton"].tap()

        let weightField = app.textFields["goalWeightField"]
        XCTAssertTrue(weightField.waitForExistence(timeout: 5))
        weightField.tap()
        weightField.typeText("100")

        app.buttons["saveGoalsButton"].tap()

        // After saving, the gauges replace the empty state and the button offers to edit.
        XCTAssertTrue(app.buttons["Edit Goals"].waitForExistence(timeout: 5), "Button should switch to Edit Goals")
        XCTAssertFalse(app.staticTexts["No Goals Set"].exists, "Empty state should be gone")
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
