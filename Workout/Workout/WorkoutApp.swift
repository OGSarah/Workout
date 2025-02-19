//
//  WorkoutApp.swift
//  Workout
//
//  Created by Sarah Clark on 2/19/25.
//

import SwiftUI

@main
struct WorkoutApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
