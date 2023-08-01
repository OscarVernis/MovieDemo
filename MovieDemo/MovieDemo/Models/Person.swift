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
                return "Female"
            case .male:
                return "Male"
            case .nonBinary:
                return "Non Binary"
            }
        }
    }
    
    enum SocialLinks: Hashable {
        case imdb(id: String)
        case facebook(username: String)
        case instagram(username: String)
        case tiktok(username: String)
        case twitter(username: String)
        case youtube(username: String)
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
    var socialLinks: [SocialLinks] = []
    
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
