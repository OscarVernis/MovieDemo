//
//  CodablePerson.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

// MARK: - CodablePerson
struct CodablePerson: Codable {
    let id: Int?
    let name: String?
    let knownForDepartment: String?
    let birthday: Date?
    let deathday: Date?
    let biography: String?
    let placeOfBirth: String?
    let profilePath: String?
    var knownForMovies: [CodableMovie]?
    let movieCredits: CodablePersonCredits?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case knownForDepartment = "known_for_department"
        case birthday
        case deathday
        case biography
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case knownForMovies = "known_for"
        case movieCredits = "movie_credits"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        knownForDepartment = try container.decodeIfPresent(String.self, forKey: .knownForDepartment)
        birthday = try container.decodeIfPresent(Date.self, forKey: .birthday)
        deathday = try container.decodeIfPresent(Date.self, forKey: .deathday)
        biography = try container.decodeIfPresent(String.self, forKey: .biography)
        placeOfBirth = try container.decodeIfPresent(String.self, forKey: .placeOfBirth)
        profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
        knownForMovies = try container.decodeIfPresent([CodableMovie].self, forKey: .knownForMovies)
        movieCredits = try container.decodeIfPresent(CodablePersonCredits.self, forKey: .movieCredits)
    }
}

// MARK: - MovieCredits
struct CodablePersonCredits: Codable {
    let cast: [CodableCastCredit]?
    let crew: [CodableCrewCredit]?
}

// MARK: - Cast
struct CodableCastCredit: Codable {
    var character: String?
    var movie: CodableMovie?

    enum CodingKeys: String, CodingKey {
        case character
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        character = try container.decodeIfPresent(String.self, forKey: .character)
        
        movie = try? CodableMovie(from: decoder)
    }
}

// MARK: - Cast
struct CodableCrewCredit: Codable {
    var job: String?
    var movie: CodableMovie?

    enum CodingKeys: String, CodingKey {
        case job
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        job = try container.decodeIfPresent(String.self, forKey: .job)
        
        movie = try? CodableMovie(from: decoder)
    }
}
