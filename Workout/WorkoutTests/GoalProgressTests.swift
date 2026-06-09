//
//  GoalProgressTests.swift
//  WorkoutTests
//

import Testing
@testable import Workout

struct GoalProgressTests {

    @Test func zeroGoalReturnsZero() {
        #expect(GoalProgress.percent(current: 50, goal: 0) == 0)
        #expect(GoalProgress.percent(current: 0, goal: 0) == 0)
    }

    @Test func negativeGoalReturnsZero() {
        #expect(GoalProgress.percent(current: 50, goal: -10) == 0)
    }

    @Test func halfwayReturnsFifty() {
        #expect(GoalProgress.percent(current: 50, goal: 100) == 50)
    }

    @Test func reachingGoalReturnsHundred() {
        #expect(GoalProgress.percent(current: 100, goal: 100) == 100)
    }

    @Test func exceedingGoalCanExceedHundred() {
        #expect(GoalProgress.percent(current: 150, goal: 100) == 150)
    }

    @Test func truncatesTowardZero() {
        // 2 / 3 = 66.6% -> 66
        #expect(GoalProgress.percent(current: 2, goal: 3) == 66)
    }
}
