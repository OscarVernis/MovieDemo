//
//  MovieService+Endpoints.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

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
    
    private func url(forPath path: String) -> URL {
        let url = URL(string: baseURL)!
        
        return url.appendingPathComponent(path)
    }
    
    func url(forEndpoint endpoint: Endpoint) -> URL {
        switch endpoint {
        case .NowPlaying:
            return url(forPath: "/movie/now_playing")
        case .Popular:
            return url(forPath: "/movie/popular")
        case .TopRated:
            return url(forPath: "/movie/top_rated")
        case .Upcoming:
            return url(forPath: "/movie/upcoming")
        case .Recommended(movieId: let movieId):
            return url(forPath: "/movie/\(movieId)/recommendations")
        case .UserFavorites:
            return url(forPath: "/account/id/favorite/movies")
        case .UserWatchList:
            return url(forPath: "/account/id/watchlist/movies")
        case .UserRated:
            return url(forPath: "/account/id/rated/movies")
        case .MovieDetails(movieId: let movieId):
            return url(forPath: "/movie/\(movieId)")
        case .Search:
            return url(forPath: "/search/multi")
        case .PersonDetails(personId: let personId):
            return url(forPath: "/person/\(personId)")
        case .UserDetails:
            return url(forPath: "/account/id")
        case .MarkAsFavorite:
            return url(forPath: "/account/id/favorite")
        case .AddToWatchlist:
            return url(forPath: "/account/id/watchlist")
        case .RateMovie(movieId: let movieId):
            return url(forPath: "/movie/\(movieId)/rating")
        case .DeleteRate(movieId: let movieId):
            return url(forPath: "/movie/\(movieId)/rating")
        case .RequestToken:
            return url(forPath: "/authentication/token/new")
        case .ValidateToken:
            return url(forPath: "/authentication/token/validate_with_login")
        case .CreateSession:
            return url(forPath: "/authentication/session/new")
        case .DeleteSession:
            return url(forPath: "/authentication/session")
        }
    }
    
}
