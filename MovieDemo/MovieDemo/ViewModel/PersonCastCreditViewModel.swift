//
//  PersonCastCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonCastCreditViewModel {
    private var castCredit: PersonCastCredit!

    init(personCastCredit: PersonCastCredit) {
        self.castCredit = personCastCredit
    }
    
    var character: String? {
        return castCredit.character
    }
    
    var movie: MovieViewModel? {
        guard let movie = castCredit.movie else { return nil }
        
        return MovieViewModel(movie: movie)
    }
    
    var title: String {
        guard let movie = movie else  { return "" }
        
        return movie.title
    }
    
    var year: String {
        guard let movie = movie, movie.releaseYear.isEmpty == false else { return "-" }
        
        return movie.releaseYear
    }
    
}
