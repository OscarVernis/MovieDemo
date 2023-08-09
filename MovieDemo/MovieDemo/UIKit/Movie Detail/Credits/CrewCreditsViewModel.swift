//
//  CrewCreditsViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

class CrewCreditsViewModel {
    var departments: [String] {
        query.isEmpty ? allDepartments : searchDepartments
    }
    private var departmentJobs: [String: [CrewCreditViewModel]] {
        query.isEmpty ? allDepartmentJobs : searchDepartmentJobs
    }
    
    private let credits: [CrewCreditViewModel]
    private let allDepartments: [String]
    private let allDepartmentJobs: [String: [CrewCreditViewModel]]
    
    var query: String = "" {
        didSet {
            updateSearchResults()
        }
    }
    private var searchDepartments: [String] = []
    private var searchDepartmentJobs: [String: [CrewCreditViewModel]] = [:]

    init(crewCredits: [CrewCreditViewModel]) {
        credits = crewCredits
        allDepartments = CrewCreditsViewModel.departments(from: crewCredits)
        allDepartmentJobs = CrewCreditsViewModel.departmentsJobs(from: crewCredits, departments: allDepartments)
    }
    
    func jobs(in department: String) -> [CrewCreditViewModel] {
        departmentJobs[department] ?? []
    }
    
    private func updateSearchResults() {
        let filteredCredits = credits.filter {
            $0.name.lowercased().contains(query.lowercased()) ||
            $0.job.lowercased().contains(query.lowercased())
        }
        searchDepartments = CrewCreditsViewModel.departments(from: filteredCredits)
        searchDepartmentJobs = CrewCreditsViewModel.departmentsJobs(from: filteredCredits, departments: searchDepartments)
    }
    
    private static func departments(from credits: [CrewCreditViewModel]) -> [String] {
        let uniqueDepartments = Set(Array(credits.compactMap(\.department)))
        return uniqueDepartments.sorted().map(CrewCreditsViewModel.localizedDepartment)
    }
    
    private static func departmentsJobs(from credits: [CrewCreditViewModel], departments: [String]) -> [String: [CrewCreditViewModel]] {
        var departmentJobs = [String: [CrewCreditViewModel]]()
        for department in departments {
            let jobs = credits.filter { CrewCreditsViewModel.localizedDepartment($0.department) == department }
            departmentJobs[department] = jobs.sorted { $0.job < $1.job }
        }
        
        return departmentJobs
    }

    private static func localizedDepartment(_ department: String?) -> String {
        guard let department else { return "" }
        
        return CrewDepartment(rawValue: department)?.localized ?? department
    }
}
