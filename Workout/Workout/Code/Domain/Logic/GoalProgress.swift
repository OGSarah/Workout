//
//  GoalProgress.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Foundation

/// Progress of a current value toward a goal, expressed as a whole percentage.
enum GoalProgress {

    /// The percentage of `goal` reached by `current`.
    ///
    /// Returns `0` when `goal` is not positive. The result can exceed `100` once the goal is
    /// surpassed, which the gauges clamp visually.
    static func percent(current: Double, goal: Double) -> Int {
        guard goal > 0 else { return 0 }
        return Int((current / goal) * 100)
    }
}
