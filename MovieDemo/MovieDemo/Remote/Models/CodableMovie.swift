//
//  CodableMovie.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let codableMovie = try? JSONDecoder().decode(CodableMovie.self, from: jsonData)

import Foundation

// MARK: - CodableMovie
struct CodableMovie: Codable {
    let id: Int!
    let title: String!
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: Date?
    let runtime: Int?
    let voteAverage: Float?
    let voteCount: Int?
    let credits: CodableCredits?
    let recommendations: ServiceModelsResult<Movie>?
    let genres: [CodableGenre]?
    let status: String?
    let popularity: Float?
    let originalLanguage: String?
    let budget: Int?
    let revenue: Int?
    let originalTitle: String?
    let productionCountries: [CodableProductionCountry]?
    
    let videos: CodableVideos?

    let accountStates: CodableAccountStates?

}

// MARK: - AccountStates
struct CodableAccountStates: Codable {
    let favorite: Bool?
    let watchlist: Bool?
    let rated: CodableRating?
}

// MARK: - Rated
struct CodableRating: Codable {
    let value: Float?
}

// MARK: - Credits
struct CodableCredits: Codable {
    let cast: [CodableCast]?
    let crew: [CodableCrew]?
}

// MARK: - Cast
struct CodableCast: Codable {
    let name: String!
    let castId: Int?
    let character: String?
    let gender: Int?
    let id: Int?
    let order: Int?
    let profilePath: String?
    
    let department: String?
    let job: String?
}

// MARK: - Crew
struct CodableCrew: Codable {
    let id: Int?
    let name: String!
    let department: String?
    let gender: Int?
    let job: String?
    let profilePath: String? 
}

// MARK: - Genre
struct CodableGenre: Codable {
    let id: Int?
}

// MARK: - ProductionCountry
struct CodableProductionCountry: Codable {
    let iso3166_1: String?
}

// MARK: - Videos
struct CodableVideos: Codable {
    let results: [CodableVideo]?
}

// MARK: - VideosResult
struct CodableVideo: Codable {
    let name: String?
    let key: String?
    let type: String?
}
