//
//  ExerciseDetailView.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import SwiftUI

struct ExerciseDetailView: View {
    @State private var exercise: Exercise
    @State private var exerciseSetSummaries: [ExerciseSetSummary]
    @Environment(\.colorScheme) var colorScheme
    @State private var showEditSheet = false
    let weightGradiant = Gradient(colors: [.lightPink, .brightCoralRed, .pink])
    let repsGradiant = Gradient(colors: [.lightYellow, .yellow, .darkYellow])
    let durationGradient = Gradient(colors: [.lightGreen, .brightLimeGreen, .green])

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray.opacity(0.6), location: 0),
            Gradient.Stop(color: .gray.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(exercise: Exercise, exerciseSetSummaries: [ExerciseSetSummary]) {
        self.exercise = exercise
        self.exerciseSetSummaries = exerciseSetSummaries
    }

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 10) {
                       // moodSection
                        goalPerformanceSection

                        chartSection
                        Spacer()
                    }
                    .padding()
                    .sheet(isPresented: $showEditSheet) {
                        EditExerciseGoalsSheet(exercise: $exercise, showEditSheet: $showEditSheet)
                    }
                }
            }
                .navigationTitle(exercise.name ?? "Empty Name")
        }
    }

    // TODO: Refactor this so you're not repeating the same code.
    private var goalPerformanceSection: some View {
        VStack {
            HStack {
                Text("Performance Goals")
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showEditSheet.toggle()
                }, label: {
                    Text("Edit")
                })
            }
            .padding(.horizontal, 20)
            HStack {
                // Weight
                Gauge(value: 10, in: 0...100) {
                    Image(systemName: "heart.fill")
                } currentValueLabel: {
                    Text("\(Int(10))%")
                } minimumValueLabel: {
                    Text("\(Int(0))")
                } maximumValueLabel: {
                    Text("\(Int(100))")
                }
                .gaugeStyle(.accessoryCircular)
                .tint(weightGradiant)
                .scaleEffect(1.5)
                .padding(.horizontal, 10)

                // Reps
                Gauge(value: 55, in: 0...100) {
                    Text("Reps")
                } currentValueLabel: {
                    Text("\(Int(55))%")
                        .font(.headline)
                } minimumValueLabel: {
                    Text("\(Int(0))")
                } maximumValueLabel: {
                    Text("\(Int(10))")
                }
                .gaugeStyle(AccessoryCircularGaugeStyle())
                .tint(repsGradiant)
                .scaleEffect(1.5)
                .padding(.horizontal, 30)

                // Duration
                Gauge(value: 95, in: 0...100) {
                    Text("Duration")
                } currentValueLabel: {
                    Text("\(Int(95))%")
                        .font(.headline)
                } minimumValueLabel: {
                    Text("\(Int(0))")
                } maximumValueLabel: {
                    Text("\(Int(90))")
                }
                .gaugeStyle(.accessoryCircular)
                .tint(durationGradient)
                .scaleEffect(1.5)
                .padding(.horizontal, 10)
            }
            .padding(40)
            .background {
                glassBackground

            }
            .padding(.bottom, 10)
        }
    }

    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Exercise Progress Overview")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal)
            .padding(.top)

            ExerciseProgressChartView(exerciseSetSummaries: exerciseSetSummaries, exerciseName: exercise.name ?? "No Exercise Name")
                .padding(.horizontal, 5)
        }
        .background {
            glassBackground
        }
        .padding(.horizontal)
    }

    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .overlay {
                // Subtle inner shadow
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        .black.opacity(0.1),
                        lineWidth: 1
                    )
                    .blur(radius: 1)
                    .mask(RoundedRectangle(cornerRadius: 15).fill(.black))
            }
            .padding(.top, 10)
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Pushups")
    let sampleSummaries = [
        ExerciseSetSummary.sample(
            id: "1",
            exerciseSetID: "set1",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 2), // 2 days ago
            completedAt: Date().addingTimeInterval(-86400 * 2),
            timeSpentActive: 60,
            weight: 20.0,
            repsReported: 10,
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise)
        ),
        ExerciseSetSummary.sample(
            id: "2",
            exerciseSetID: "set2",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400), // 1 day ago
            completedAt: Date().addingTimeInterval(-86400),
            timeSpentActive: 60,
            weight: 25.0,
            repsReported: 12,
            exerciseSet: ExerciseSet.sample(id: "set2", exercise: sampleExercise)
        ),
        ExerciseSetSummary.sample(
            id: "3",
            exerciseSetID: "set3",
            workoutSummaryID: nil,
            startedAt: Date(), // Today
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise)
        )
    ]
    ExerciseDetailView(exercise: sampleExercise, exerciseSetSummaries: sampleSummaries)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Pushups")
    let sampleSummaries = [
        ExerciseSetSummary.sample(
            id: "1",
            exerciseSetID: "set1",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 2), // 2 days ago
            completedAt: Date().addingTimeInterval(-86400 * 2),
            timeSpentActive: 60,
            weight: 20.0,
            repsReported: 10,
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise)
        ),
        ExerciseSetSummary.sample(
            id: "2",
            exerciseSetID: "set2",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400), // 1 day ago
            completedAt: Date().addingTimeInterval(-86400),
            timeSpentActive: 60,
            weight: 25.0,
            repsReported: 12,
            exerciseSet: ExerciseSet.sample(id: "set2", exercise: sampleExercise)
        ),
        ExerciseSetSummary.sample(
            id: "3",
            exerciseSetID: "set3",
            workoutSummaryID: nil,
            startedAt: Date(), // Today
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise)
        )
    ]
    ExerciseDetailView(exercise: sampleExercise, exerciseSetSummaries: sampleSummaries)
        .preferredColorScheme(.dark)
}
