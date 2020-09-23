//
//  Movie+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Foundation
import ObjectMapper

class Movie: Mappable {
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
    var originalLanguage: String?
    var budget: Int?
    var revenue: Int?
    
    var favorite: Bool = false
    var rated: Bool = false
    var watchlist: Bool = false
    
    
//MARK: - ObjectMapper
    public required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        
        if map.JSON["title"] == nil {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        backdropPath <- map["backdrop_path"]
        id <- map["id"]
        overview <- map["overview"]
        posterPath <- map["poster_path"]
        releaseDate <- (map["release_date"], CustomDateFormatTransform(formatString: "yyyy-MM-dd"))
        title <- map["title"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
        runtime <- map["runtime"]
        genres <- (map["genre_ids"], MovieGenreTransformer()) //Movie lists return genres as this: "genre_ids": [14, 28, 80]
        genres <- (map["genres"], MovieGenreDictionaryTransformer()) //Movie details returns as this: "genres": [{" id": 18, "name": "Drama" }]
        cast <- map["credits.cast"]
        crew <- map["credits.crew"]
        recommendedMovies <- map["recommendations.results"]
        status <- map["status"]
        originalLanguage <- map["original_language"]
        budget <- map["budget"]
        revenue <- map["revenue"]
        
        favorite <- map["account_states.favorite"]
        rated <- map["account_states.rated"]
        watchlist <- map["account_states.watchlist"]
    }
    
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
