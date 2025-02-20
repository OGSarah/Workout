//
//  UUID+Extensions.swift
//  Future
//

import Foundation

extension UUID {
    
    public static var nilUUID: UUID {
        return UUID(uuidString: self.nilUUIDString)!
    }
    
    public static var nilUUIDString: String {
        return "00000000-0000-0000-0000-000000000000"
    }
    
}
