//
//  MovieService+Endpoints.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

//MARK: - HTTPMethods
extension MovieService {
    enum HTTPMethod: String {
        case connect = "CONNECT"
        case delete = "DELETE"
        case get = "GET"
        case head = "HEAD"
        case options = "OPTIONS"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
        case trace = "TRACE"
    }
}

//MARK: - Endpoints
extension MovieService {    
    enum Endpoint {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
        case Recommended(movieId: Int)
        case UserFavorites
        case UserWatchList
        case UserRated
        case MovieDetails(movieId: Int)
        case Search
        case PersonDetails(personId: Int)
        case UserDetails
        case MarkAsFavorite
        case AddToWatchlist
        case RateMovie(movieId: Int)
        case DeleteRate(movieId: Int)
        case RequestToken
        case ValidateToken
        case CreateSession
        case DeleteSession
    }
    
    func urlforEndpoint(_ endpoint: Endpoint, parameters: [String: String]? = nil) -> URL {
        let path = pathforEndpoint(endpoint)
        
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
    
    private func pathforEndpoint(_ endpoint: Endpoint) -> String {
        switch endpoint {
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
        case .MovieDetails(movieId: let movieId):
            return "/movie/\(movieId)"
        case .Search:
            return "/search/multi"
        case .PersonDetails(personId: let personId):
            return "/person/\(personId)"
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
        case .RequestToken:
            return "/authentication/token/new"
        case .ValidateToken:
            return "/authentication/token/validate_with_login"
        case .CreateSession:
            return "/authentication/session/new"
        case .DeleteSession:
            return "/authentication/session"
        }
    }
    
}
