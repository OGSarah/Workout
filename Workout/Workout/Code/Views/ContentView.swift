//
//  ContentView.swift
//  Workout
//
//  Created by Sarah Clark on 2/19/25.
//

import SwiftUI

struct ContentView: View {
    let workoutsController = WorkoutsController()

    var body: some View {
            ExerciseListView(workoutsController: workoutsController)
        }
    }

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
