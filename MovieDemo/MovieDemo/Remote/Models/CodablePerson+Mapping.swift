//
//  CodablePerson+Mapping.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension CodablePerson {
    func toPerson() -> Person {
        var person = Person()
        
        person.id = id
        person.name = name
        person.knownForDepartment = knownForDepartment
        person.birthday = birthday
        person.deathday = deathday
        person.biography = biography
        person.placeOfBirth = placeOfBirth
        person.profilePath = profilePath
        person.knownForMovies = knownForMovies?.toMovies()
        person.castCredits = movieCredits?.cast?.compactMap { $0.toPersonCastCredit() }
        person.crewCredits = movieCredits?.crew?.compactMap { $0.toPersonCrewCredit() }
        
        return person
    }
}

extension CodableCastCredit {
    func toPersonCastCredit() -> PersonCastCredit {
        var credit = PersonCastCredit()
        
        credit.character = character
        credit.movie = movie?.toMovie()
        
        return credit
    }
}

extension CodableCrewCredit {
    func toPersonCrewCredit() -> PersonCrewCredit {
        var credit = PersonCrewCredit()
        
        credit.job = job
        credit.movie = movie?.toMovie()
        
        return credit
    }
}
