//
//  String+Extensions.swift
//  Future
//

import Foundation

extension String {
    
    public var isNilUUIDString: Bool {
        return self == UUID.nilUUIDString
    }
    
}

extension Optional where Wrapped == String {
    
    public var isEmpty: Bool {
        guard let self = self else { return true }
        return self.isEmpty
    }
    
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    public var nilIfEmpty: String? {
        return isNotEmpty ? self : nil
    }
    
}
