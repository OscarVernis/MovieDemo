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
        let cache = ManagedCache.uniqueInstance(in: store.context)
        let managedMovies = NSOrderedSet(array: movies.compactMap { MovieMO(withMovie: $0, context: store.context) })
        
        
        switch movieList {
        case .NowPlaying:
            cache.addToNowPlaying(managedMovies)
        case .Popular:
            cache.addToPopular(managedMovies)
        case .TopRated:
            cache.addToTopRated(managedMovies)
        case .Upcoming:
            cache.addToUpcoming(managedMovies)
        default:
            break
        }
        
        store.save()
    }
    
    func delete(movieList: MovieList) {
        let cache = ManagedCache.uniqueInstance(in: store.context)
        
        switch movieList {
        case .NowPlaying:
            let managedMovies = cache.nowPlaying ?? NSOrderedSet()
            cache.removeFromNowPlaying(managedMovies)
        case .Popular:
            let managedMovies = cache.popular ?? NSOrderedSet()
            cache.removeFromPopular(managedMovies)
        case .TopRated:
            let managedMovies = cache.topRated ?? NSOrderedSet()
            cache.removeFromTopRated(managedMovies)
        case .Upcoming:
            let managedMovies = cache.upcoming ?? NSOrderedSet()
            cache.removeFromUpcoming(managedMovies)
        default:
            break
        }
        
        store.save()
    }
    
}

extension MovieCache: MovieLoader {
    func getMovies(movieList: MovieList, page: Int, completion: @escaping MovieListCompletion) {
        let totalPages = 1
        let cache = ManagedCache.uniqueInstance(in: store.context)
        var managedMovies: [MovieMO]?
        
        switch movieList {
        case .NowPlaying:
            managedMovies = cache.nowPlaying?.array as? [MovieMO]
        case .Popular:
            managedMovies = cache.popular?.array as? [MovieMO]
        case .TopRated:
            managedMovies = cache.topRated?.array as? [MovieMO]
        case .Upcoming:
            managedMovies = cache.upcoming?.array as? [MovieMO]
        default:
            break
        }
        
        var movies = [Movie]()
        if let managedMovies = managedMovies {
        movies = managedMovies.compactMap { $0.toMovie() }
        }
                
        completion(.success((movies, totalPages)))
    }
    
}
