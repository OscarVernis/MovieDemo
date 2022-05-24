//
//  Endpoint.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

//MARK: - Endpoint
struct Endpoint {
    var path: String
}

//MARK: - Movie Lists
extension Endpoint {
    static func movies(_ endpoint: MoviesEndpoint) -> Endpoint {
        Endpoint(path: endpoint.path)
    }
}

enum MoviesEndpoint {
    case NowPlaying
    case Popular
    case TopRated
    case Upcoming
    case Recommended(movieId: Int)
    case UserFavorites
    case UserWatchList
    case UserRated
    
    var path: String {
        switch self {
        case .NowPlaying:
            return "/movie/now_playing"
        case .Popular:
            return "/movie/popular"
        case .TopRated:
            return "/movie/top_rated"
        case .Upcoming:
            return "/movie/upcoming"
        case .Recommended(movieId: let movieId):
            return "/movie/\(movieId)/recommendations"
        case .UserFavorites:
            return "/account/id/favorite/movies"
        case .UserWatchList:
            return "/account/id/watchlist/movies"
        case .UserRated:
            return "/account/id/rated/movies"
        }
    }
    
}

//MARK: - Search
extension Endpoint {
    static var search: Endpoint {
        Endpoint(path: "/search/multi")
    }
}

//MARK: - Details
extension Endpoint {
    static func movieDetails(movieId: Int) -> Endpoint {
        Endpoint(path: "/movie/\(movieId)")
    }
    
    static func personDetails(personId: Int) -> Endpoint {
        Endpoint(path: "/person/\(personId)")
    }
}

//MARK: - User
extension Endpoint {
    static var userDetails: Endpoint {
        Endpoint(path: "/account/id")
    }
    
    static var markAsFavorite: Endpoint {
        Endpoint(path: "/account/id/favorite")
    }
    
    static var addToWatchlist: Endpoint {
        Endpoint(path: "/account/id/watchlist")
    }
    
    static func rateMovie(_ movieId: Int) -> Endpoint {
        Endpoint(path: "/movie/\(movieId)/rating")
    }
    
    static func deleteRate(_ movieId: Int) -> Endpoint {
        Endpoint(path: "/movie/\(movieId)/rating")
    }
}

//MARK: - Session
extension Endpoint {
    static var requestToken: Endpoint {
        Endpoint(path: "/authentication/token/new")
    }
    
    static var validateToken: Endpoint {
        Endpoint(path: "/authentication/token/validate_with_login")
    }
    
    static var createSession: Endpoint {
        Endpoint(path: "/authentication/session/new")
    }
    
    static var deleteSession: Endpoint {
        Endpoint(path: "/authentication/session")
    }
    
}
