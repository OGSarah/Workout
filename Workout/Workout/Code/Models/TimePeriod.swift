//
//  TimePeriod.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import Foundation

/// The window of time used to filter and label progress data in the charts.
enum TimePeriod: String, CaseIterable, Identifiable, Sendable {
    case week
    case month
    case sixMonths
    case year

    var id: Self { self }

    /// Human-readable label used by the time-period picker.
    var title: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .sixMonths: return "6 Months"
        case .year: return "Year"
        }
    }
}
