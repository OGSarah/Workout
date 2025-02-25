//
//  ContentView.swift
//  Workout
//
//  Created by Sarah Clark on 2/19/25.
//

import SwiftUI

struct ContentView: View {
    let workoutsController = WorkoutsController()

    @State private var goalWeight: Double = UserDefaults.standard.double(forKey: "goalWeight")
    @State private var goalReps: Int = UserDefaults.standard.integer(forKey: "goalReps")
    @State private var goalDuration: Int = UserDefaults.standard.integer(forKey: "goalDuration")

    var body: some View {
        ExerciseListView(
            workoutsController: workoutsController,
            goalWeight: $goalWeight,
            goalReps: $goalReps,
            goalDuration: $goalDuration
        )
        .onChange(of: goalWeight) {_, newValue in
            UserDefaults.standard.set(newValue, forKey: "goalWeight")
        }
        .onChange(of: goalReps) {_, newValue in
            UserDefaults.standard.set(newValue, forKey: "goalReps")
        }
        .onChange(of: goalDuration) {_, newValue in
            UserDefaults.standard.set(newValue, forKey: "goalDuration")
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
