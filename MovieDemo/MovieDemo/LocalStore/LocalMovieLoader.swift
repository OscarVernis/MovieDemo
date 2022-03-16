//
//  LocalMovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct LocalMovieLoader: MovieLoader {    
    func getMovies(movieList: MovieList, page: Int, completion: @escaping MovieListCompletion) {
        var movies = [Movie]()
        
        switch movieList {
        case .NowPlaying:
            let managedMovies = CoreDataStore.shared.fetchAll(entity: Movie_NowPlayingMO.self)
            movies = managedMovies.compactMap { $0.toMovie() }
        case .Popular:
            let managedMovies = CoreDataStore.shared.fetchAll(entity: Movie_PopularMO.self)
            movies = managedMovies.compactMap { $0.toMovie() }
        case .TopRated:
            let managedMovies = CoreDataStore.shared.fetchAll(entity: Movie_TopRatedMO.self)
            movies = managedMovies.compactMap { $0.toMovie() }
        case .Upcoming:
            let managedMovies = CoreDataStore.shared.fetchAll(entity: Movie_UpcomingMO.self)
            movies = managedMovies.compactMap { $0.toMovie() }
        default:
            break
        }
        
        completion(.success((movies, 1)))
    }
    
}
