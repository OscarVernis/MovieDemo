//
//  PersonCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

class PersonCreditViewModel {
    var id: Int
    
    var department: String?
    
    var job: String?
    
    var movie: MovieViewModel?
    
    var title: String {
        movie?.title ?? ""
    }
    
    var year: String
    
    var releaseDate: Date?
    
    init(id: Int, department: String? = nil, job: String? = nil, movie: MovieViewModel? = nil, year: String = "") {
        self.id = id
        self.department = department
        self.job = job
        self.movie = movie
        self.year = year
    }
}

extension PersonCreditViewModel {
    convenience init(castCredit: PersonCastCredit) {
        self.init(id: castCredit.id)
        
        department = CrewDepartment.Acting.rawValue
        job = castCredit.character
        if let castMovie = castCredit.movie {
            movie = MovieViewModel(movie: castMovie)
        }
        year = movie?.releaseYear ?? ""
        releaseDate = castCredit.movie?.releaseDate
    }
    
    convenience init(crewCredit: PersonCrewCredit) {
        self.init(id: crewCredit.id)
        
        department = crewCredit.department
        job = crewCredit.job
        if let castMovie = crewCredit.movie {
            movie = MovieViewModel(movie: castMovie)
        }
        year = movie?.releaseYear ?? ""
        releaseDate = crewCredit.movie?.releaseDate
    }
    
}

extension PersonCreditViewModel {
    static func sortByRelease(lhs: PersonCreditViewModel, rhs: PersonCreditViewModel) -> Bool {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 100
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        
        return lhs.releaseDate ?? futureDate > rhs.releaseDate ?? futureDate
    }
}

extension PersonCreditViewModel: Hashable {
    static func == (lhs: PersonCreditViewModel, rhs: PersonCreditViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
