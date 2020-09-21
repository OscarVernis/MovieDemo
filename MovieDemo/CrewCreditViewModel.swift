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
            
    init(crewCredit: CrewCredit) {
        self.crewCredit = crewCredit
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
