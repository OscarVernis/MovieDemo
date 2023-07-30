//
//  PersonCrewCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class PersonCrewCreditViewModel {
    private var crewCredit: PersonCrewCredit!

    init(personCrewCredit: PersonCrewCredit) {
        crewCredit = personCrewCredit
    }
    
    var id: Int {
        crewCredit.id
    }
    
    var job: String? {
        crewCredit.job
    }
    
    var movie: MovieViewModel? {
        guard let movie = crewCredit.movie else { return nil }
        
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

extension PersonCrewCreditViewModel: Hashable {
    static func == (lhs: PersonCrewCreditViewModel, rhs: PersonCrewCreditViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
