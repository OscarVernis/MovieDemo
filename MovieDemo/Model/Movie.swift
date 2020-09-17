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
        genres <- (map["genre_ids"], MovieGenreTransformer())
    }
    
}

