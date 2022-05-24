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
        return service.getModels(endpoint: .movies(movieList), page: page)
            .map { (movies, totalPages) in
                MoviesResults(movies: movies, totalPages: totalPages)
            }
            .eraseToAnyPublisher()
    }
    
}
