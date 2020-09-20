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
    var backdropPath: String?
    var id: Int?
    var overview: String?
    var posterPath: String?
    var releaseDate: Date?
    var runtime: Int?
    var title: String?
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
    
    
//MARK: - ObjectMapper
    public required init?(map: Map) {
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
