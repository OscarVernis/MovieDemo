//
//  MovieCrewCreditsViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

struct MovieCrewCreditsViewModel {
    let departments: [String]
    let departmentJobs: [String: [CrewCreditViewModel]]

    init(crewCredits: [CrewCreditViewModel]) {
        let uniqueDeparments = Set(Array(crewCredits.compactMap(\.department)))
        departments = uniqueDeparments.sorted()
        
        var departmentJobs = [String: [CrewCreditViewModel]]()
        for department in departments {
            let jobs = crewCredits.filter { $0.department == department }
            departmentJobs[department] = jobs.sorted { $0.job < $1.job }
        }
        self.departmentJobs = departmentJobs
    }

}
