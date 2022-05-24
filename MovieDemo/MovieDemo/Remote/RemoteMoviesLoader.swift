//
//  RemoteMovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteMoviesLoader: MovieLoader {
    let service: MovieService
    
    init(sessionId: String? = nil) {
        self.service = MovieService(sessionId: sessionId)
    }
    
    func getMovies(movieList: MovieList, page: Int) -> AnyPublisher<MoviesResults, Error> {
        return service.getModels(endpoint: endpoint(movieList: movieList), page: page)
            .map { (movies, totalPages) in
                MoviesResults(movies: movies, totalPages: totalPages)
            }
            .eraseToAnyPublisher()
    }
    
    func endpoint(movieList: MovieList) -> MovieService.Endpoint {
        switch movieList {
        case .NowPlaying:
            return .NowPlaying
        case .Popular:
            return .Popular
        case .TopRated:
            return .TopRated
        case .Upcoming:
            return .Upcoming
        case .Recommended(movieId: let movieId):
            return .Recommended(movieId: movieId)
        case .UserFavorites:
            return .UserFavorites
        case .UserWatchList:
            return .UserWatchList
        case .UserRated:
            return .UserRated
        }
    }
    
}
