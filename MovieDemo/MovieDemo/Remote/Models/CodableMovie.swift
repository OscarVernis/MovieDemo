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

//MARK: - CodableMovie
struct CodableMovie: Codable {
    let id: Int!
    let title: String!
    let tagline: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: Date?
    let runtime: Int?
    let voteAverage: Float?
    let voteCount: Int?
    let credits: CodableCredits?
    let recommendations:  ServiceModelsResult<CodableMovie>?
    let genres: [CodableGenre]?
    let genreIds: [Int]?
    let status: String?
    let popularity: Float?
    let originalLanguage: String?
    let budget: Int?
    let revenue: Int?
    let originalTitle: String?
    let productionCountries: [CodableProductionCountry]?
    let videos: CodableVideos?
    let accountStates: CodableAccountStates?
    let homepage: String?
    let externalIds: ExternalIds?
    let watchProviders: CodableWatchProvidersResult?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case tagline
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case credits
        case recommendations
        case genres
        case genreIds = "genre_ids"
        case status
        case popularity
        case originalLanguage = "original_language"
        case budget
        case revenue
        case originalTitle = "original_title"
        case productionCountries = "production_countries"
        case videos
        case accountStates = "account_states"
        case homepage
        case externalIds = "external_ids"
        case watchProviders = "watch/providers"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        tagline = try? container.decodeIfPresent(String.self, forKey: .tagline)
        overview = try? container.decodeIfPresent(String.self, forKey: .overview)
        posterPath = try? container.decodeIfPresent(String.self, forKey: .posterPath)
        backdropPath = try? container.decodeIfPresent(String.self, forKey: .backdropPath)
        releaseDate = try? container.decodeIfPresent(Date.self, forKey: .releaseDate)
        runtime = try? container.decodeIfPresent(Int.self, forKey: .runtime)
        voteAverage = try? container.decodeIfPresent(Float.self, forKey: .voteAverage)
        voteCount = try? container.decodeIfPresent(Int.self, forKey: .voteCount)
        credits = try? container.decodeIfPresent(CodableCredits.self, forKey: .credits)
        recommendations = try? container.decodeIfPresent(ServiceModelsResult<CodableMovie>.self, forKey: .recommendations)
        genres = try? container.decodeIfPresent([CodableGenre].self, forKey: .genres)
        genreIds = try? container.decodeIfPresent([Int].self, forKey: .genreIds)
        status = try? container.decodeIfPresent(String.self, forKey: .status)
        popularity = try? container.decodeIfPresent(Float.self, forKey: .popularity)
        originalLanguage = try? container.decodeIfPresent(String.self, forKey: .originalLanguage)
        budget = try? container.decodeIfPresent(Int.self, forKey: .budget)
        revenue  = try? container.decodeIfPresent(Int.self, forKey: .revenue)
        originalTitle = try? container.decodeIfPresent(String.self, forKey: .originalTitle)
        productionCountries = try? container.decodeIfPresent([CodableProductionCountry].self, forKey: .productionCountries)
        videos = try? container.decodeIfPresent(CodableVideos.self, forKey: .videos)
        accountStates = try? container.decodeIfPresent(CodableAccountStates.self, forKey: .accountStates)
        homepage = try? container.decodeIfPresent(String.self, forKey: .homepage)
        externalIds = try? container.decodeIfPresent(ExternalIds.self, forKey: .externalIds)
        watchProviders = try? container.decodeIfPresent(CodableWatchProvidersResult.self, forKey: .watchProviders)
    }
    
}

//MARK: - AccountStates
struct CodableAccountStates: Codable {
    let favorite: Bool?
    let watchlist: Bool?
    let rated: CodableRatingItem?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        favorite = try? container.decode(Bool.self, forKey: .favorite)
        watchlist = try? container.decode(Bool.self, forKey: .watchlist)
        let ratingItem = try? container.decodeIfPresent(CodableRatingItem.self, forKey: .rated)
        
        if let ratingItem {
            rated = ratingItem
        } else {
            rated = nil
        }
    }
}

//MARK: - Rated
struct CodableRatingItem: Codable {
    let value: Float?
}

//MARK: - Credits
struct CodableCredits: Codable {
    let cast: [CodableCast]?
    let crew: [CodableCrew]?
}

//MARK: - Cast
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
    
    enum CodingKeys: String, CodingKey {
        case name
        case castId = "cast_id"
        case character
        case gender
        case id
        case order
        case profilePath = "profile_path"
        case department
        case job
    }
}

//MARK: - Crew
struct CodableCrew: Codable {
    let id: Int?
    let name: String!
    let department: String?
    let gender: Int?
    let job: String?
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case department
        case gender
        case job
        case profilePath = "profile_path"
    }
}

//MARK: - Genre
struct CodableGenre: Codable {
    let id: Int?
}

//MARK: - ProductionCountry
struct CodableProductionCountry: Codable {
    let iso3166_1: String?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
    }
}

//MARK: - Videos
struct CodableVideos: Codable {
    let results: [CodableVideo]?
}

//MARK: - VideosResult
struct CodableVideo: Codable {
    let name: String?
    let key: String?
    let type: String?
}
