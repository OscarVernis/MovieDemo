//
//  RemoteMoviesLoaderWithCache.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct RemoteMoviesLoaderWithCache: MovieLoader {
    let remoteMoviesLoader = RemoteMoviesLoader(sessionId: SessionManager.shared.sessionId)
    let movieCache = MovieCache()
    
    func getMovies(movieList: MovieList, page: Int, completion: @escaping MovieListCompletion) {
        //Only load from cache if loading the first page
        if page == 1 {
            movieCache.getMovies(movieList: movieList, page: page, completion: { result in })
        }
        
        //Load movies from service
        remoteMoviesLoader.getMovies(movieList: movieList, page: page) { result in
            if case .success((let movies, _)) = result {
                //delete cache if loading the first page
                if page == 1 {
                    movieCache.delete(movieList: movieList)
                }
                
                //Save movies to cache
                movieCache.save(movies: movies, movieList: movieList)
            }
            
            completion(result)
        }
        
    }
    
}
