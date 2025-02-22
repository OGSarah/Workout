//
//  EditExerciseGoalsSheet.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

struct EditExerciseGoalsSheet: View {
    @Binding var exerciseSetSummary: ExerciseSetSummary
    @Environment(\.dismiss) var dismiss
    @Binding var exercise: Exercise

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Goals")) {
                    TextField("Weight", value: $exerciseSetSummary.weight, formatter: decimalFormatter)
                    TextField("Reps", value: $exerciseSetSummary.repsReported, formatter: integerFormatter)
                    TextField("Duration", value: $exerciseSetSummary.timeSpentActive, formatter: integerFormatter)
                }
            }
            .navigationTitle("Edit \(exercise.name ?? "Exercise")")
            .navigationBarItems(leading: Button("Cancel") { dismiss() }, trailing: Button("Save") { dismiss() })
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
