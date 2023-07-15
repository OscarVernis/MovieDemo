//
//  Person.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct Person {
    var id: Int!
    var name: String!
    var knownForDepartment: String?
    var birthday: Date?
    var deathday: Date?
    var gender: Int?
    var biography: String?
    var placeOfBirth: String?
    var profilePath: String?
    var knownForMovies: [Movie]?
    
    var castCredits: [PersonCastCredit]?
    var crewCredits: [PersonCrewCredit]?
}

//MARK: - Utils
extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return
            lhs.id == rhs.id
    }
}
