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
                    // `LabeledContent` already supplies the visible + VoiceOver label for each field,
                    // so we avoid adding a second `accessibilityLabel` that would be read twice.
                    LabeledContent("Weight Goal (lbs)") {
                        TextField("Weight", value: $viewModel.draftWeight, formatter: decimalFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .accessibilityIdentifier(AccessibilityIdentifiers.EditGoals.weightField)
                    }
                    LabeledContent("Reps Goal") {
                        TextField("Reps", value: $viewModel.draftReps, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier(AccessibilityIdentifiers.EditGoals.repsField)
                    }
                    LabeledContent("Duration Goal (min)") {
                        TextField("Duration", value: $viewModel.draftDuration, formatter: integerFormatter)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier(AccessibilityIdentifiers.EditGoals.durationField)
                    }
                }
            }
            .navigationTitle("Edit \(viewModel.title) Goals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.cancelEditingGoals() }
                        .accessibilityIdentifier(AccessibilityIdentifiers.EditGoals.cancelButton)
                        .accessibilityHint("Closes the editor without saving changes")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { viewModel.saveGoals() }
                        .accessibilityIdentifier(AccessibilityIdentifiers.EditGoals.saveButton)
                        .accessibilityHint("Saves your exercise goals")
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

#Preview("Empty Fields") {
    EditExerciseGoalsSheet(viewModel: PreviewData.detailViewModel(withGoals: false))
}
