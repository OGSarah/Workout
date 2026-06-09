//
//  EditExerciseGoalsSheet.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

/// A sheet for editing an exercise's weight, reps, and duration goals.
struct EditExerciseGoalsSheet: View {
    @Bindable var viewModel: ExerciseDetailViewModel

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            Form {
                Section("Edit Goals") {
                    LabeledContent("Weight Goal (lbs)") {
                        TextField("Weight", value: $viewModel.draftWeight, formatter: decimalFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .accessibilityIdentifier("goalWeightField")
                    }
                    LabeledContent("Reps Goal") {
                        TextField("Reps", value: $viewModel.draftReps, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("goalRepsField")
                    }
                    LabeledContent("Duration Goal (min)") {
                        TextField("Duration", value: $viewModel.draftDuration, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("goalDurationField")
                    }
                }
            }
            .navigationTitle("Edit \(viewModel.title) Goals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.cancelEditingGoals() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { viewModel.saveGoals() }
                        .accessibilityIdentifier("saveGoalsButton")
                }
            }
        }
    }

    // MARK: - Formatters
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
    EditExerciseGoalsSheet(viewModel: PreviewData.detailViewModel(withGoals: true))
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    EditExerciseGoalsSheet(viewModel: PreviewData.detailViewModel(withGoals: true))
        .preferredColorScheme(.dark)
}
