//
//  WorkoutApp.swift
//  Workout
//
//  Created by Sarah Clark on 2/19/25.
//

import SwiftData
import SwiftUI

@main
struct WorkoutApp: App {

    /// UI tests launch with `--uitesting` so goals are kept in memory and each run starts clean.
    private var isUITesting: Bool {
        CommandLine.arguments.contains("--uitesting")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExerciseGoal.self, inMemory: isUITesting)
    }

}
