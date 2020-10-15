//
//  PersonCastCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonCastCreditViewModel: MovieViewModel {
    private weak var castCredit: PersonCastCredit!

    init(personCastCredit: PersonCastCredit) {
        self.castCredit = personCastCredit
        super.init(movie: personCastCredit)
    }
    
    var character: String? {
        return castCredit.character
    }
    
    var year: String {
        return releaseYear.isEmpty == false ? releaseYear : "-"
    }
    
}
