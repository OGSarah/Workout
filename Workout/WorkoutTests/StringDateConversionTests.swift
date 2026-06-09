//
//  StringDateConversionTests.swift
//  WorkoutTests
//

import Foundation
import Testing
@testable import Workout

struct StringDateConversionTests {

    @Test func parsesRFC3339WithSubseconds() {
        #expect("2026-02-15T15:18:43.221Z".asDate() != nil)
    }

    @Test func parsesInternetDateTime() {
        #expect("2026-02-15T15:18:43Z".asDate() != nil)
    }

    @Test func parsesDateOnly() {
        #expect("2026-02-15".asDate() != nil)
    }

    @Test func returnsNilForPlaceholderDates() {
        #expect("0001-01-01".asDate() == nil)
        #expect("0001-01-01T00:00:00Z".asDate() == nil)
    }

    @Test func returnsNilForGarbage() {
        #expect("not a date".asDate() == nil)
        #expect("".asDate() == nil)
    }

    @Test func roundTripsThroughSubsecondFormatter() throws {
        let original = "2026-02-15T15:18:43.221Z"
        let date = try #require(original.asDate())
        let formatted = date.asString(includeSubseconds: true)
        #expect(formatted == original)
    }
}
