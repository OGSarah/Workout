//
//  ExerciseSet.swift
//  Future
//

import Foundation
import HealthKit

public enum ExerciseSetType: String, Codable, CaseIterable {
    case unknown = ""
    case reps = "reps"
    case duration = "duration"
    case distance = "distance"
}

/// This is one set of an exercise created by the coach for the user to perform. For example, 12 reps of Bicep Curls at 30 lbs
public struct ExerciseSet: Codable, Equatable {
    public var id: String
    public var exercise: Exercise?
    public var type: ExerciseSetType = .unknown
    public var reps: Int?
    public var duration: Int?
    public var weight: Float?
    public var position: Int?
    public var distance: Double?
    public var estimatedDuration: Int?
    public var intensity: String?
    public var isTwoDumbbells: Bool?
    
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case exercise = "exercise"
        case type = "type"
        case reps = "reps"
        case duration = "duration"
        case weight = "weight"
        case position = "position"
        case distance = "distance"
        case estimatedDuration = "estimated_duration"
        case startTiming = "start_timing"
        case intensity = "intensity"
        case isTwoDumbbells = "is_two_dumbbells"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.exercise = try container.decodeIfPresent(Exercise.self, forKey: .exercise)
        self.type = (try? container.decode(ExerciseSetType.self, forKey: .type)) ?? .unknown
        self.reps = try container.decodeIfPresent(Int.self, forKey: .reps)
        self.duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        self.weight = try container.decodeIfPresent(Float.self, forKey: .weight)
        self.position = try container.decodeIfPresent(Int.self, forKey: .position)
        self.distance = try container.decodeIfPresent(Double.self, forKey: .distance)
        self.estimatedDuration = try container.decodeIfPresent(Int.self, forKey: .estimatedDuration)
        self.intensity = try container.decodeIfPresent(String.self, forKey: .intensity)
        self.isTwoDumbbells = try container.decodeIfPresent(Bool.self, forKey: .isTwoDumbbells)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.exercise, forKey: .exercise)
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encodeIfPresent(self.reps, forKey: .reps)
        try container.encodeIfPresent(self.duration, forKey: .duration)
        try container.encodeIfPresent(self.weight, forKey: .weight)
        try container.encodeIfPresent(self.position, forKey: .position)
        try container.encodeIfPresent(self.distance, forKey: .distance)
        try container.encodeIfPresent(self.estimatedDuration, forKey: .estimatedDuration)
        try container.encodeIfPresent(self.intensity, forKey: .intensity)
        try container.encodeIfPresent(self.isTwoDumbbells, forKey: .isTwoDumbbells)
    }
    
    // MARK: Helpers
    
    public var isRecovery: Bool {
        return (self.exercise?.type ?? "") == "rest"
    }
    
    public var weightUnit: String {
        return (isTwoDumbbells ?? false) ? "lb dumbbells" : "lbs"
    }
    
}

public enum Intensity: String {
    case none = ""
    case tempoFast = "tempo_fast"
    case tempoModerate = "tempo_moderate"
    case tempoSlow = "tempo_slow"
    case paceFast = "pace_fast"
    case paceModerate = "pace_moderate"
    case paceSlow = "pace_slow"
    case effortMax = "effort_max"
    case paceMax = "pace_max"
    case amrap = "amrap"
    case repsFast = "reps_fast"
    case repsSlow = "reps_slow"
    case resistanceLow = "resistance_low"
    case resistanceMedium = "resistance_medium"
    case resistanceHigh = "resistance_high"
    case speedRPMUnder65 = "speed_rpm_under_65"
    case speedRPM65to80 = "speed_rpm_65_80"
    case speedRPM80to90 = "speed_rpm_80_90"
    case speedRPMOver110 = "speed_rpm_over_110"
    case light = "light"
    case slow = "slow"
    case weightHeavy = "weight_heavy"
    case weightLight = "weight_light"
    case weightModerate = "weight_moderate"
    
    public var displayName: String {
        switch self {
        case .none: return "Normal"
        case .tempoFast: return "Fast Tempo"
        case .tempoModerate: return "Moderate Tempo"
        case .tempoSlow: return "Slow Tempo"
        case .paceFast: return "Fast Pace"
        case .paceModerate: return "Moderate Pace"
        case .paceSlow: return "Slow Pace"
        case .effortMax: return "Max Effort"
        case .paceMax: return "Max Pace"
        case .amrap: return "AMRAP"
        case .repsFast: return "Fast Reps"
        case .repsSlow: return "Slow Reps"
        case .light: return "Light"
        case .slow: return "Slow"
        case .weightHeavy: return "Heavy"
        case .weightLight: return "Light"
        case .weightModerate: return "Moderate"
        case .resistanceLow: return "Low Resistance"
        case .resistanceMedium: return "Medium Resistance"
        case .resistanceHigh: return "High Resistance"
        case .speedRPMUnder65: return "Under 65 RPM"
        case .speedRPM65to80: return "65 to 80 RPM"
        case .speedRPM80to90: return "80 to 90 RPM"
        case .speedRPMOver110: return "Over 100 RPM"
        }
    }
}
