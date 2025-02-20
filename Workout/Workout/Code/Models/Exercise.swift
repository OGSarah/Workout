//
//  Exercise.swift
//  Future
//

import Foundation

/// This is the exercise model, can be used to relate different sets in the same workouts or across different workouts
public struct Exercise: Codable, Equatable {
    public var id: String
    public var name: String?
    public var side: String?
    public var description: String?
    public var isAlternating: Bool = false
    public var isDuration: Bool = false
    public var isReps: Bool = false
    public var isTwoDumbbells: Bool = false
    public var isWeight: Bool = false
    public var movementPatterns: String?
    public var muscleGroups: String?
    public var type: String?
    
    public enum CodingKeys: String, CodingKey {
        case description = "description"
        case id = "id"
        case isAlternating = "is_alternating"
        case isDuration = "is_duration"
        case isReps = "is_reps"
        case isTwoDumbbells = "is_two_dumbbells"
        case isWeight = "is_weight"
        case movementPatterns = "movement_patterns"
        case muscleGroups = "muscle_groups"
        case name = "name"
        case side = "side"
        case type = "type"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.id = try container.decode(String.self, forKey: .id)
        self.isAlternating = try container.decodeIfPresent(Bool.self, forKey: .isAlternating) ?? false
        self.isDuration = try container.decodeIfPresent(Bool.self, forKey: .isDuration) ?? false
        self.isReps = try container.decodeIfPresent(Bool.self, forKey: .isReps) ?? false
        self.isTwoDumbbells = try container.decodeIfPresent(Bool.self, forKey: .isTwoDumbbells) ?? false
        self.isWeight = try container.decodeIfPresent(Bool.self, forKey: .isWeight) ?? false
        self.movementPatterns = try container.decodeIfPresent(String.self, forKey: .movementPatterns)
        self.muscleGroups = try container.decodeIfPresent(String.self, forKey: .muscleGroups)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.side = try container.decodeIfPresent(String.self, forKey: .side)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.isAlternating, forKey: .isAlternating)
        try container.encodeIfPresent(self.isDuration, forKey: .isDuration)
        try container.encodeIfPresent(self.isReps, forKey: .isReps)
        try container.encodeIfPresent(self.isTwoDumbbells, forKey: .isTwoDumbbells)
        try container.encodeIfPresent(self.isWeight, forKey: .isWeight)
        try container.encodeIfPresent(self.movementPatterns, forKey: .movementPatterns)
        try container.encodeIfPresent(self.muscleGroups, forKey: .muscleGroups)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.side, forKey: .side)
        try container.encodeIfPresent(self.type, forKey: .type)
    }
    
}

// MARK: Helpers
extension Exercise {
    
    public var sideDisplayName: String? {
        guard let side = side else { return nil }
        return Side(rawValue: side)?.displayName
    }
    
}

public enum Side: String {
    case right = "right_side"
    case left = "left_side"
    case rightArm = "right_arm"
    case leftArm = "left_arm"
    case rightLeg = "right_leg"
    case leftLeg = "left_leg"
    
    public var displayName: String {
        switch self {
        case .left: return "Left Side"
        case .right: return "Right Side"
        case .leftArm: return "Left Arm"
        case .rightArm: return "Right Arm"
        case .leftLeg: return "Left Leg"
        case .rightLeg: return "Right Leg"
        }
    }
}
