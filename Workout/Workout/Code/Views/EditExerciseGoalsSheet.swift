//
//  EditExerciseGoalsSheet.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

struct EditExerciseGoalsSheet: View {
    // @Binding var exerciseSetSummary: [ExerciseSetSummary]
    @Binding var exercise: Exercise
    @Binding var showEditSheet: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Goals")) {
                    TextField("Weight", value: .constant(0.0), formatter: decimalFormatter)
                    TextField("Reps", value: .constant(0), formatter: integerFormatter)
                    TextField("Duration", value: .constant(0), formatter: integerFormatter)
                }
            }
            .navigationTitle("Edit \(exercise.name ?? "Exercise")")
            .navigationBarItems(leading: Button("Cancel") {
                showEditSheet = false
            }, trailing: Button("Save") {
                showEditSheet = false
            })
        }
    }

    private var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2 // Adjust as needed
        return formatter
    }

    private var integerFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
}

// TODO: Add preview code
