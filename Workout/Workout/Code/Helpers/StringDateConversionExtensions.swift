//
//  StringDateConversionExtensions.swift
//  Future
//

import Foundation

extension Date {
    
    public static let iso8601DateOnlyFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()
    
    public static let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withColonSeparatorInTimeZone, .withTimeZone]
        return formatter
    }()
    
    public static let rfc3339DateFormatterWithSubseconds: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    public func asString(includeSeconds: Bool = true, includeSubseconds: Bool = true) -> String? {
        if includeSeconds == false {
            return Date.iso8601DateOnlyFormatter.string(from: self)
        } else if includeSubseconds == true {
            return Date.rfc3339DateFormatterWithSubseconds.string(from: self)
        } else {
            return Date.iso8601DateFormatter.string(from: self)
        }
    }
    
}

extension String {
    
    public func asDate() -> Date? {
        guard self != "0001-01-01" else {
            return nil
        }
        
        guard self != "0001-01-01T00:00:00Z" else {
            return nil
        }
        
        if let string = Date.rfc3339DateFormatterWithSubseconds.date(from: self) {
            return string
        } else if let string = Date.iso8601DateFormatter.date(from: self) {
            return string
        }
        return Date.iso8601DateOnlyFormatter.date(from: self)
    }
    
}
