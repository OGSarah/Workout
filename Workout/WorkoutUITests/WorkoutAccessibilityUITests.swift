//
//  WorkoutAccessibilityUITests.swift
//  WorkoutUITests
//
//  Verifies the app is usable with VoiceOver and at accessibility Dynamic Type sizes.
//

import XCTest

final class WorkoutAccessibilityUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["--uitesting"]
    }

    /// Exercise rows expose a human-readable VoiceOver label rather than a raw identifier.
    @MainActor
    func testExerciseRowsHaveAccessibilityLabels() throws {
        app.launch()
        let list = app.collectionViews[AccessibilityIdentifiers.ExerciseList.list]
        XCTAssertTrue(list.waitForExistence(timeout: 15))

        let firstRow = list.buttons.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 10))
        XCTAssertTrue(firstRow.label.lowercased().contains("exercise"), "Rows should read as '<name> exercise'")
    }

    /// The goal editor's fields carry meaningful, non-empty VoiceOver labels (supplied by LabeledContent).
    @MainActor
    func testGoalEditorControlsAreAccessible() throws {
        app.launch()
        let list = app.collectionViews[AccessibilityIdentifiers.ExerciseList.list]
        XCTAssertTrue(list.waitForExistence(timeout: 15))
        list.buttons.firstMatch.tap()

        let editButton = app.buttons[AccessibilityIdentifiers.ExerciseDetail.editGoalsButton]
        XCTAssertTrue(editButton.waitForExistence(timeout: 5))
        editButton.tap()

        let weightField = app.textFields[AccessibilityIdentifiers.EditGoals.weightField]
        XCTAssertTrue(weightField.waitForExistence(timeout: 5))
        XCTAssertTrue(weightField.label.contains("Weight"), "Weight field should have a descriptive label")
    }

    /// The list still loads and is interactive at an accessibility Dynamic Type size.
    @MainActor
    func testListLoadsAtAccessibilityTextSize() throws {
        app.launchArguments += ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXL"]
        app.launch()

        let list = app.collectionViews[AccessibilityIdentifiers.ExerciseList.list]
        XCTAssertTrue(list.waitForExistence(timeout: 15), "List should load at accessibility text size")
        let firstRow = list.buttons.firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 10))
        XCTAssertTrue(firstRow.isHittable, "Rows should remain tappable at large text sizes")
    }
}
