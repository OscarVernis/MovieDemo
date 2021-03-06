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

class Movie: MediaItem {
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
    
    
//MARK: - ObjectMapper
    override class func objectForMapping(map: Map) -> BaseMappable? {
        if map.JSON["id"] == nil {
            return nil
        }
        
        if map.JSON["title"] == nil {
            return nil
        }
        
        return Movie()
    }
    
    public override func mapping(map: Map) {
        backdropPath <- map["backdrop_path"]
        id <- map["id"]
        overview <- map["overview"]
        posterPath <- map["poster_path"]
        releaseDate <- (map["release_date"], CustomDateFormatTransform(formatString: "yyyy-MM-dd"))
        title <- map["title"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
        runtime <- map["runtime"]
        genres <- (map["genre_ids"], MovieGenreTransformer()) //Movie list services return genres as this: "genre_ids": [14, 28, 80]
        genres <- (map["genres"], MovieGenreDictionaryTransformer()) //Movie details service returns as this: "genres": [{" id": 18, "name": "Drama" }]
        cast <- map["credits.cast"]
        crew <- map["credits.crew"]
        recommendedMovies <- map["recommendations.results"]
        status <- map["status"]
        popularity <- map["popularity"]
        originalLanguage <- map["original_language"]
        budget <- map["budget"]
        revenue <- map["revenue"]
        originalTitle <- map["original_title"]
        productionCountries <- (map["production_countries"], CountryArrayTransformer())

        videos <- map["videos.results"]
        
        favorite <- map["account_states.favorite"]
        rated <- (map["account_states.rated"], MovieUserRatedTransform()) //Service returns false if not rated, and the value of the rating if rated.
        userRating <- map["account_states.rated.value"]
        watchlist <- map["account_states.watchlist"]
        
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
