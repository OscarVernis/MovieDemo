//
//  PersonCrewCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonCrewCreditViewModel: MovieViewModel {
    private weak var crewCredit: PersonCrewCredit!

    init(personCrewCredit: PersonCrewCredit) {
        self.crewCredit = personCrewCredit
        super.init(movie: personCrewCredit)
    }
    
    var job: String? {
        return crewCredit.job
    }
    
    var year: String {
        return releaseYear.isEmpty == false ? releaseYear : "-"
    }
    
}
