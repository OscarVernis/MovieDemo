//
//  MovieService+Endpoints.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

//MARK: - Endpoints
protocol Endpoint {
    var path: String { get }
}

//MARK: - Helper
extension MovieService {
    func urlforEndpoint(_ endpoint: Endpoint, parameters: [String: String]? = nil) -> URL {
        let path = endpoint.path
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = "/3" + path
        
        let params = defaultParameters(additionalParameters: parameters)
        components.queryItems = params.compactMap{ URLQueryItem(name: $0.0, value: $0.1) }
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
    
}

//MARK: - Endpoints
enum MoviesEndpoint: Endpoint {
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

struct MovieDetailsEndpoint: Endpoint {
    let movieId: Int
    
    var path: String {
        "/movie/\(movieId)"
    }
}

struct SearchEndpoint: Endpoint {
    var path: String {
        "/search/multi"
    }
}

struct PersonDetailsEndpoint: Endpoint {
    let personId: Int
    
    var path: String {
        "/person/\(personId)"
    }
}

enum UserEndpoint: Endpoint {
    case UserDetails
    case MarkAsFavorite
    case AddToWatchlist
    case RateMovie(movieId: Int)
    case DeleteRate(movieId: Int)
    
    var path: String {
        switch self {
        case .UserDetails:
            return "/account/id"
        case .MarkAsFavorite:
            return "/account/id/favorite"
        case .AddToWatchlist:
            return "/account/id/watchlist"
        case .RateMovie(movieId: let movieId):
            return "/movie/\(movieId)/rating"
        case .DeleteRate(movieId: let movieId):
            return "/movie/\(movieId)/rating"
        }
    }
    
}

enum SessionEndpoint: String, Endpoint {
    case RequestToken = "/authentication/token/new"
    case ValidateToken = "/authentication/token/validate_with_login"
    case CreateSession = "/authentication/session/new"
    case DeleteSession = "/authentication/session"
    
    var path: String {
        self.rawValue
    }
}
