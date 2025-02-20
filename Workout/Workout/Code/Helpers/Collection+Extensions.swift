//
//  Collection+Extensions.swift
//  Future
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    public var isNotEmpty: Bool {
        return self.isEmpty == false
    }
    
}
