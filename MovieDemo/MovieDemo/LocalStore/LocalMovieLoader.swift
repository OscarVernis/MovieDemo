//
//  LocalMovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import CoreStore

struct LocalMovieLoader: MovieLoader {
    func getMovies(movieList: MovieList, page: Int, completion: @escaping MovieListCompletion) {
        var movies = [Movie]()
        
        switch movieList {
        case .NowPlaying:
            let managedMovies = try? CoreStoreDefaults.dataStack.fetchAll(From<Movie_NowPlayingMO>())
            movies = managedMovies?.compactMap { $0.toMovie() } ?? [Movie]()
        case .Popular:
            let managedMovies = try? CoreStoreDefaults.dataStack.fetchAll(From<Movie_PopularMO>())
            movies = managedMovies?.compactMap { $0.toMovie() } ?? [Movie]()
        case .TopRated:
            let managedMovies = try? CoreStoreDefaults.dataStack.fetchAll(From<Movie_TopRatedMO>())
            movies = managedMovies?.compactMap { $0.toMovie() } ?? [Movie]()
        case .Upcoming:
            let managedMovies = try? CoreStoreDefaults.dataStack.fetchAll(From<Movie_UpcomingMO>())
            movies = managedMovies?.compactMap { $0.toMovie() } ?? [Movie]()
        default:
            break
        }
        
        completion(.success((movies, 1)))
    }
    
}
