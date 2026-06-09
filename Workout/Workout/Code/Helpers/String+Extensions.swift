//
//  String+Extensions.swift
//  Workout
//

import Foundation

extension Optional where Wrapped == String {

    var isEmpty: Bool {
        guard let self else { return true }
        return self.isEmpty
    }

    var isNotEmpty: Bool {
        !self.isEmpty
    }

    /// The string when it has content, otherwise `nil`. Used to normalise empty JSON strings to `nil`.
    var nilIfEmpty: String? {
        isNotEmpty ? self : nil
    }

}
