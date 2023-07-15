//
//  Movie.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Foundation

struct Movie {
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
    
    var favorite: Bool? = false
    var userRating: Float? = nil
    var watchlist: Bool? = false
}

//MARK: - Utils
extension Movie: Codable {}

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
