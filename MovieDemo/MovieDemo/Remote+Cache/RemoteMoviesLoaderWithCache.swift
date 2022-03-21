//
//  RemoteMoviesLoaderWithCache.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteMoviesLoaderWithCache: MovieLoader {
    let remoteMoviesLoader = RemoteMoviesLoader(sessionId: SessionManager.shared.sessionId)
    let movieCache = MovieCache()
    
    func getMovies(movieList: MovieList, page: Int) -> AnyPublisher<([Movie], Int), Error> {
        return remoteMoviesLoader.getMovies(movieList: movieList, page: page)
            .caching(movieCache, page: page, movieList: movieList)
            .catch { error  in
                return movieCache.getMovies(movieList: movieList, page: page)
            }
            .eraseToAnyPublisher()
    }
    
}

extension Publisher where Output == ([Movie], Int) {
    func caching(_ movieCache: MovieCache, page: Int, movieList: MovieList) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { (movies, totalPages) in
            if page == 1 {
                movieCache.delete(movieList: movieList)
            }
            
            //Save movies to cache
            movieCache.save(movies: movies, movieList: movieList)
        })
        .eraseToAnyPublisher()
    }

}
