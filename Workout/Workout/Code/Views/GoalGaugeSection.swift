//
//  GoalGaugeSection.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

struct GoalGaugeSection: View {
    @Binding var exercise: Exercise
    @Binding var showEditSheet: Bool
    let weightGradient = Gradient(colors: [.lightPink, .brightCoralRed, .pink])
    let repsGradient = Gradient(colors: [.lightYellow, .yellow, .darkYellow])
    let durationGradient = Gradient(colors: [.lightGreen, .brightLimeGreen, .green])

    var body: some View {
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
                .tint(weightGradient)
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
                .gaugeStyle(.accessoryCircular) // Fixed typo: Changed AccessoryCircularGaugeStyle() to .accessoryCircular
                .tint(repsGradient)
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

    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.5),
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

/*
#Preview {
    GoalGaugeSection(
        exercise: .constant(Exercise(name: "Pushups")),
        showEditSheet: .constant(false)
    )
}
*/
