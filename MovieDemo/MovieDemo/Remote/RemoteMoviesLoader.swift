//
//  RemoteMovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteMoviesLoader: MoviesLoader {
    let service: TMDBClient
    let movieList: MoviesEndpoint
    
    init(movieList: MoviesEndpoint, sessionId: String? = nil) {
        self.service = TMDBClient(sessionId: sessionId)
        self.movieList = movieList
    }
    
    func getMovies(page: Int) -> AnyPublisher<MoviesResult, Error> {
        let publisher: AnyPublisher<ServiceModelsResult<Movie>, Error> = service.getModels(endpoint: .movies(movieList), page: page)
        
        return publisher
            .map { result in
                MoviesResult(movies: result.items, totalPages: result.totalPages)
            }
            .eraseToAnyPublisher()
        
    }
    
}
