//
//  StringExtensionTests.swift
//  WorkoutTests
//

import Foundation
import Testing
@testable import Workout

struct StringExtensionTests {

    @Test func nilIfEmptyReturnsNilForEmptyString() {
        let empty: String? = ""
        #expect(empty.nilIfEmpty == nil)
    }

    @Test func nilIfEmptyReturnsValueForNonEmptyString() {
        let value: String? = "Squat"
        #expect(value.nilIfEmpty == "Squat")
    }

    @Test func optionalIsEmptyTreatsNilAsEmpty() {
        let none: String? = nil
        let empty: String? = ""
        let value: String? = "x"
        #expect(none.isEmpty)
        #expect(empty.isEmpty)
        #expect(value.isEmpty == false)
    }

    @Test func optionalIsNotEmptyIsInverse() {
        let value: String? = "x"
        let none: String? = nil
        #expect(value.isNotEmpty)
        #expect(none.isNotEmpty == false)
    }
}
