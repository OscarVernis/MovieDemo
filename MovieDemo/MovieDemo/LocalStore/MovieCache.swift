//
//  LocalMovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct MovieCache {
    private var store = CoreDataStore.shared
    
    func save(movies: [Movie], movieList: MovieList) {
        var managedMovies: [MovieMO]? = nil
        let context = store.context
        
        switch movieList {
        case .NowPlaying:
            managedMovies = movies.compactMap { Movie_NowPlayingMO(withMovie: $0, context: context) }
        case .Popular:
            managedMovies = movies.compactMap { Movie_PopularMO(withMovie: $0, context: context) }
        case .TopRated:
            managedMovies = movies.compactMap { Movie_TopRatedMO(withMovie: $0, context: context) }
        case .Upcoming:
            managedMovies = movies.compactMap { Movie_UpcomingMO(withMovie: $0, context: context) }
        default:
            break
        }
        
        if managedMovies != nil {
            store.save()
        }
    }
    
    func delete(movieList: MovieList) {
        switch movieList {
        case .NowPlaying:
            store.deleteAll(entity: Movie_NowPlayingMO.self)
        case .Popular:
            store.deleteAll(entity: Movie_PopularMO.self)
        case .TopRated:
            store.deleteAll(entity: Movie_TopRatedMO.self)
        case .Upcoming:
            store.deleteAll(entity: Movie_UpcomingMO.self)
        default:
            break
        }
    }
    
}

extension MovieCache: MovieLoader {
    func getMovies(movieList: MovieList, page: Int, completion: @escaping MovieListCompletion) {
        var movies = [Movie]()
        let totalPages = 1
        
        switch movieList {
        case .NowPlaying:
            let managedMovies = store.fetchAll(entity: Movie_UpcomingMO.self)
            movies = managedMovies.compactMap { $0.toMovie() }
        case .Popular:
            let managedMovies = store.fetchAll(entity: Movie_PopularMO.self)
            movies = managedMovies.compactMap { $0.toMovie() }
        case .TopRated:
            let managedMovies = store.fetchAll(entity: Movie_UpcomingMO.self)
            movies = managedMovies.compactMap { $0.toMovie() }
        case .Upcoming:
            let managedMovies = store.fetchAll(entity: Movie_UpcomingMO.self)
            movies = managedMovies.compactMap { $0.toMovie() }
        default:
            break
        }
        
        completion(.success((movies, totalPages)))
    }
    
}
