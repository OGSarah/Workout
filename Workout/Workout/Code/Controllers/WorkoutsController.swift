//
//  WorkoutsController.swift
//  Future
//
//

import Foundation

public class WorkoutsController {
    
    public private(set) var workoutSummaries = [WorkoutSummary]()
    
    init() {
        let summaryUrls = Bundle.main.urls(forResourcesWithExtension: ".json", subdirectory: nil) ?? []
        
        for summaryUrl in summaryUrls {
            if let workoutSummaryData = try? Data(contentsOf: summaryUrl),
               let workoutSummary = try? JSONDecoder().decode(WorkoutSummary.self, from: workoutSummaryData) {
                workoutSummaries.append(workoutSummary)
            }
        }
        
        print("Loaded \(workoutSummaries.count) workout summaries.")
    }
    
}
