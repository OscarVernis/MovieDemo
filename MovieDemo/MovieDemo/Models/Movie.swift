//
//  Movie+CoreDataClass.swift
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

//MARK: - Codable
extension Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case cast = "cast"
        case crew = "crew"
        case genres = "genre_ids"
        case status = "status"
        case popularity = "popularity"
        case originalLanguage = "original_language"
        case budget = "budget"
        case revenue = "revenue"
        case originalTitle = "original_title"
        case productionCountries = "production_countries"
        case favorite = "favorite"
        case userRating = "rated"
        case watchlist = "watchlist"
    }
    
    enum NestedKeys: String, CodingKey {
        case recommendations
        case videos
        case credits
        case accountStates = "account_states"
    }
    
    enum SpecialKeys: String, CodingKey {
        case genres
        case results
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        releaseDate = try container.decodeIfPresent(Date.self, forKey: .releaseDate)
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        voteAverage = try container.decodeIfPresent(Float.self, forKey: .voteAverage)
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        genres = try container.decodeIfPresent([MovieGenre].self, forKey: .genres)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        popularity = try container.decodeIfPresent(Float.self, forKey: .popularity)
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        revenue  = try container.decodeIfPresent(Int.self, forKey: .revenue)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        
        let nestedContainer = try decoder.container(keyedBy: NestedKeys.self)
        
        let countriesContainer = try decoder.container(keyedBy: CodingKeys.self)
        let countries = try countriesContainer.decodeIfPresent([[String: String]].self, forKey: .productionCountries)
        productionCountries = countries?.compactMap { $0["iso_3166_1"] }
        
        //Movie details service returns as this: "genres": [{" id": 18, "name": "Drama" }]
        let genresContainer = try decoder.container(keyedBy: SpecialKeys.self)
        let tempGenres  = try genresContainer.decodeIfPresent([ServiceGenre].self, forKey: .genres)
        if tempGenres != nil {
            genres = tempGenres?.compactMap { MovieGenre(rawValue: $0.id) }
        }
        
        let videoContainer = try nestedContainer.nestedContainer(keyedBy: SpecialKeys.self, forKey: .videos)
        videos = try videoContainer.decodeIfPresent([MovieVideo].self, forKey: .results)
        
        let recommendationsContainer = try nestedContainer.nestedContainer(keyedBy: SpecialKeys.self, forKey: .recommendations)
        recommendedMovies = try recommendationsContainer.decodeIfPresent([Movie].self, forKey: .results)
        
        let creditsContainer = try nestedContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .credits)
        cast = try creditsContainer.decodeIfPresent([CastCredit].self, forKey: .cast)
        crew = try creditsContainer.decodeIfPresent([CrewCredit].self, forKey: .crew)
        
        let accountStatesContainer = try nestedContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .accountStates)
        favorite = try accountStatesContainer.decodeIfPresent(Bool.self, forKey: .favorite)
        watchlist = try accountStatesContainer.decodeIfPresent(Bool.self, forKey: .watchlist)
        
        let ratingContainer = try accountStatesContainer.nestedContainer(keyedBy: SpecialKeys.self, forKey: .userRating)
        userRating = try ratingContainer.decodeIfPresent(Float.self, forKey: .value)
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
