//
//  PersonCastCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class PersonCastCreditViewModel {
    private var castCredit: PersonCastCredit!

    init(personCastCredit: PersonCastCredit) {
        castCredit = personCastCredit
    }
    
    var id: Int {
        castCredit.id
    }
    
    var character: String? {
        castCredit.character
    }
    
    var movie: MovieViewModel? {
        guard let movie = castCredit.movie else { return nil }
        
        return MovieViewModel(movie: movie)
    }
    
    var title: String {
        guard let movie = movie else  { return "" }
        
        return movie.title
    }
    
    var year: String? {
        guard let movie = movie, !movie.releaseYear.isEmpty else { return nil }
        
        return movie.releaseYear
    }
    
}

extension PersonCastCreditViewModel: Hashable {
    static func == (lhs: PersonCastCreditViewModel, rhs: PersonCastCreditViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
