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
    let localMoviesLoader = LocalMovieLoader()
    
    func getMovies(movieList: MovieList, page: Int, completion: @escaping MovieListCompletion) {
        //Only load from cache if loading the first page
        if page == 0 {
            localMoviesLoader.getMovies(movieList: movieList, page: page, completion: completion)
        }
        
        remoteMoviesLoader.getMovies(movieList: movieList, page: page) { result in
            if page == 0 {
                //delete cache if loading the first page
            }
            
            //Save movies to cache
            if case .success((_, _)) = result {
            }
            
            completion(result)
        }
        
    }
    
}
