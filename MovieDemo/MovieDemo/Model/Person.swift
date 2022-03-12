//
//  Person.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class Person: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case knownForDepartment = "known_for_department"
        case birthday
        case deathday
        case gender
        case biography
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case knownForMovies = "known_for"
        case castCredits = "cast"
        case crewCredits = "crew"
    }
    
    enum NestedKeys: String, CodingKey {
        case movieCredits = "movie_credits"
    }
    
    required init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        knownForDepartment = try container.decodeIfPresent(String.self, forKey: .knownForDepartment)
        birthday = try container.decodeIfPresent(Date.self, forKey: .birthday)
        deathday = try container.decodeIfPresent(Date.self, forKey: .deathday)
        biography = try container.decodeIfPresent(String.self, forKey: .biography)
        placeOfBirth = try container.decodeIfPresent(String.self, forKey: .placeOfBirth)
        profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
        knownForMovies = try container.decodeIfPresent([Movie].self, forKey: .knownForMovies)
        
        do {
            let nestedContainer = try decoder.container(keyedBy: NestedKeys.self)
            
            let creditsContainer = try nestedContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .movieCredits)
            crewCredits = try creditsContainer.decodeIfPresent([PersonCrewCredit].self, forKey: .crewCredits)
            castCredits = try creditsContainer.decodeIfPresent([PersonCastCredit].self, forKey: .castCredits)
        } catch { }
    }
}
