//
//  RemoteMovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct RemoteMoviesLoader: MovieLoader {
    let sessionId: String?
    let service: MovieDBService
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
        self.service = MovieDBService(sessionId: sessionId)
    }
    
    func getMovies(movieList: MovieList, page: Int, completion: @escaping MovieListCompletion) {
        service.getModels(endpoint: endpoint(movieList: movieList), sessionId: self.sessionId, parameters: parameters(movieList: movieList), page: page, completion: completion)
    }
    
    func endpoint(movieList: MovieList) -> String {
        switch movieList {
        case .NowPlaying:
            return "/movie/now_playing"
        case .Popular:
            return "/movie/popular"
        case .TopRated:
            return "/movie/top_rated"
        case .Upcoming:
            return "/movie/upcoming"
        case .Search(query: _):
            return "/search/movie"
        case .Trending:
            return "/movie/week"
        case .Recommended(movieId: let movieId):
            return "/movie/\(movieId)/recommendations"
        case .DiscoverWithCast(castId: _), .DiscoverWithCrew(crewId: _):
            return "/discover/movie"
        case .UserFavorites:
            return "/account/id/favorite/movies"
        case .UserWatchList:
            return "/account/id/watchlist/movies"
        case .UserRated:
            return "/account/id/rated/movies"
        }
    }
    
    func parameters(movieList: MovieList) -> [String: Any] {
        switch movieList {
        case .Search(query: let query):
            return ["query" : query]
        case .DiscoverWithCast(castId: let castId):
            return ["with_cast": castId]
        case .DiscoverWithCrew(crewId: let crewId):
            return ["with_crew": crewId]
        default:
            return [:]
        }
    }
    
}
