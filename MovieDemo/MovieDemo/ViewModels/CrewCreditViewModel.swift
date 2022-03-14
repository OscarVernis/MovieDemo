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
        let topJobs = TopCrewJob.allCases
        for job in topJobs {
            let creditWithJob = credits.first { $0.job == job.rawValue }
            if creditWithJob != nil {
                jobsArray.append(job.creditTitle)
            }
        }

        jobs = jobsArray.joined(separator: ", ")

    }
    
    func person() -> PersonViewModel {
        var person = Person()
        person.id = id
        person.name = name
        person.profilePath = crewCredit.profilePath
        
        return PersonViewModel(person: person)
    }
}

extension CrewCreditViewModel {
    var id: Int {
        crewCredit.id
    }
    
    var name: String {
        crewCredit.name
    }
    
    var job: String {
        crewCredit.job ?? ""
    }
    
    var profileImageURL: URL? {
        guard let pathString = crewCredit.profilePath else { return nil }
        
        return MovieDBService.profileImageURL(forPath: pathString, size: .h632)
    }
}

extension CrewCreditViewModel {
    //Used to filter the top crew jobs to show on the detail
    enum TopCrewJob: String, CaseIterable {
        case Director
        case Writer
        case Story
        case Characters
        case Screenplay
        case DOP = "Director of Photography"
        case Composer = "Original Music Composer"
        case Editor = "Editor"
        
        var creditTitle: String {
            switch self {
            case .Director:
                return NSLocalizedString("Director", comment: "")
            case .Writer:
                return NSLocalizedString("Writer", comment: "")
            case .Story:
                return NSLocalizedString("Story", comment: "")
            case .Screenplay:
                return NSLocalizedString("Screenplay", comment: "")
            case .DOP:
                return NSLocalizedString("Cinematography", comment: "")
            case .Composer:
                return NSLocalizedString("Music", comment: "")
            case .Editor:
                return NSLocalizedString("Editor", comment: "")
            case .Characters:
                return NSLocalizedString("Characters", comment: "")
            }
        }
    }
    
    static func crewWithTopJobs(credits: [CrewCredit]) -> [CrewCreditViewModel] {
        var uniqueIds = Set<Int>()
        var filteredCredits = [CrewCreditViewModel]()
        
        let topJobs = TopCrewJob.allCases.map(\.rawValue)
        for topJob in topJobs {
            let creditsWithJob = credits.filter { $0.job == topJob }
            for credit in creditsWithJob {
                if !uniqueIds.contains(credit.id) {
                    uniqueIds.insert(credit.id)
                    
                    let allCredits = credits.filter { $0.id == credit.id }
                    if let viewModel = CrewCreditViewModel(credits: allCredits) {
                        filteredCredits.append(viewModel)
                    }
                }
            }
        }
        
        return filteredCredits
    }
}
