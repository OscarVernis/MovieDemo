//
//  CrewCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class CrewCreditViewModel {
    let crewCredit: CrewCredit
        
    var jobs: String?
    
    init(crewCredit: CrewCredit) {
        self.crewCredit = crewCredit
    }
    
    init?(credits: [CrewCredit]) {
        if credits.count == 0 {
            return nil
        }
        
        self.crewCredit = credits.first!
        
        var jobsArray = [String]()
        for job in CrewCreditViewModel.topJobs {
            let creditWithJob = credits.first { $0.job == job }
            if creditWithJob != nil {
                jobsArray.append(job)
            }
        }
        
        jobs = jobsArray.joined(separator: ", ")
    }
        
    //Used to filter the top crew jobs to show on the detail
    private static var topJobs: [String] {
        return [
            "Director",
            "Writer",
            "Story",
            "Screenplay",
            "Editor",
            "Director of Photography",
            "Original Music Composer"
        ]
    }
    
    static func crewWithTopJobs(credits: [CrewCredit]) -> [CrewCreditViewModel] {
        var uniqueIds = Set<Int>()
        var filteredCredits = [CrewCreditViewModel]()
        
        for topJob in topJobs {
            let creditsWithJob = credits.filter { $0.job == topJob }
            for credit in creditsWithJob {
                if !uniqueIds.contains(credit.id!) {
                    uniqueIds.insert(credit.id!)
                    
                    let allCredits = credits.filter { $0.id == credit.id! }
                    if let viewModel = CrewCreditViewModel(credits: allCredits) {
                        filteredCredits.append(viewModel)
                    }
                }
            }
        }
        
        return filteredCredits
    }
}

extension CrewCreditViewModel {
    var name: String {
        crewCredit.name ?? ""
    }
    
    var job: String {
        crewCredit.job ?? ""
    }
        
    var profileImageURL: URL? {
        guard let pathString = crewCredit.profilePath else { return nil }
        
        return MovieDBService.profileImageURL(forPath: pathString, size: .h632)
    }
}
