//
//  EditExerciseGoalsSheet.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

struct EditExerciseGoalsSheet: View {
    @Binding var exercise: Exercise
    @Binding var showEditSheet: Bool
    @State var goalMaxWeight: Double = 0
    @State var goalMaxReps: Int = 0
    @State var goalMaxDuration: Int = 0

    // Add completion handler to pass updated goals back
    let onSave: (Double, Int, Int) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Goals")) {
                    HStack {
                        Text("Weight Goal (lbs)")
                        Spacer()
                        TextField("Weight", value: $goalMaxWeight, formatter: decimalFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Reps Goal")
                        Spacer()
                        TextField("Reps", value: $goalMaxReps, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    HStack {
                        Text("Duration Goal (min)")
                        Spacer()
                        TextField("Duration", value: $goalMaxDuration, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationTitle("Edit \(exercise.name ?? "Exercise") goals")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showEditSheet = false
                },
                trailing: Button("Save") {
                    onSave(goalMaxWeight, goalMaxReps, goalMaxDuration)
                    showEditSheet = false
                }
            )
        }
    }

    private var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }

    private var integerFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Bench Press")
    EditExerciseGoalsSheet(
        exercise: .constant(sampleExercise),
        showEditSheet: .constant(true),
        onSave: { weight, reps, duration in
            // Empty closure for preview purposes
            print("Saved: Weight: \(weight), Reps: \(reps), Duration: \(duration)")
        }
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Bench Press")
    EditExerciseGoalsSheet(
        exercise: .constant(sampleExercise),
        showEditSheet: .constant(true),
        onSave: { weight, reps, duration in
            // Empty closure for preview purposes
            print("Saved: Weight: \(weight), Reps: \(reps), Duration: \(duration)")
        }
    )
    .preferredColorScheme(.dark)
}
