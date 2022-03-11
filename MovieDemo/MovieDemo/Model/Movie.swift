//
//  Movie+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Foundation
import KeyedCodable

class Movie: Codable {
    var id: Int!
    var title: String!
    var overview: String?
    var posterPath: String?
    var backdropPath: String?
    var releaseDate: Date?
    var runtime: Int?
    var voteAverage: Float?
    var voteCount: Int?
    var cast: [CastCredit]?
    var crew: [CrewCredit]?
    var recommendedMovies: [Movie]?
    var genres: [MovieGenre]?
    var status: String?
    var popularity: Float?
    var originalLanguage: String?
    var budget: Int?
    var revenue: Int?
    var originalTitle: String?
    var productionCountries: [String]?
    
    var videos: [MovieVideo]?
    
    var favorite: Bool = false
    var rated: Bool = false
    var userRating: Float = 0
    var watchlist: Bool = false
    
    enum CodingKeys: String, KeyedKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case cast = "credits.cast"
        case crew = "credits.crew"
        case recommendedMovies = "recommendations.results"
        case genres = "genres"
        case status = "status"
        case popularity = "popularity"
        case originalLanguage = "original_language"
        case budget = "budget"
        case revenue = "revenue"
        case originalTitle = "original_title"
        case productionCountries = "production_countries"
        case videos = "videos.results"
//        case favorite = "account_states.favorite"
//        case rated = "account_states.rated"
//        case userRating = "account_states.rated.value"
//        case watchlist = "account_states.watchlist"
        }
}

//MARK: - Utils
extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return
            lhs.id == rhs.id
    }
}

extension Movie {
    static func sortByPopularity(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.voteCount ?? 0 > rhs.voteCount ?? 0
    }
    
    static func sortByRelease(lhs: Movie, rhs: Movie) -> Bool {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 100
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
        
        return lhs.releaseDate ?? futureDate > rhs.releaseDate ?? futureDate
    }
}
