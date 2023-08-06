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
        let uniqueDepartments = Set(Array(crewCredits.compactMap(\.department)))
        departments = uniqueDepartments.sorted().map(MovieCrewCreditsViewModel.localizedDepartment)
        
        var departmentJobs = [String: [CrewCreditViewModel]]()
        for department in departments {
            let jobs = crewCredits.filter { MovieCrewCreditsViewModel.localizedDepartment($0.department) == department }
            departmentJobs[department] = jobs.sorted { $0.job < $1.job }
        }
        self.departmentJobs = departmentJobs
    }

    private static func localizedDepartment(_ department: String?) -> String {
        guard let department else { return "" }
        
        return CrewDepartment(rawValue: department)?.localized ?? department
    }
}
