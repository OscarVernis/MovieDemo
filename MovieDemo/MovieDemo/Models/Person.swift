//
//  Person.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct Person {
    enum Gender: Int, Hashable {
        case female = 1
        case male = 2
        case nonBinary = 3
        
        var string: String {
            switch self {
            case .female:
                return PersonString.Female.localized
            case .male:
                return PersonString.Male.localized
            case .nonBinary:
                return PersonString.NonBinary.localized
            }
        }
    }
    
    var id: Int!
    var name: String!
    var knownForDepartment: String?
    var birthday: Date?
    var deathday: Date?
    var gender: Gender?
    var biography: String?
    var placeOfBirth: String?
    var profilePath: String?
    var knownForMovies: [Movie]?
    
    var homepage: URL?
    var socialLinks: [SocialLink] = []
    
    var castCredits: [PersonCastCredit]?
    var crewCredits: [PersonCrewCredit]?
}
