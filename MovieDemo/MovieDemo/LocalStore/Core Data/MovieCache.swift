//
//  LocalMovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine
import CoreData

struct MovieCache {
    enum CacheList {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
    }
    
    private var store = CoreDataStore.shared
    
    var cacheList: CacheList
    
    init(cacheList: CacheList) {
        self.cacheList = cacheList
    }
    
}

extension MovieCache: ModelCache {
    typealias Model = [Movie]
    func load() -> [Movie] {
        let cache = ManagedCache.uniqueInstance(in: store.context)
        var managedMovies: [MovieMO]?
        
        switch cacheList {
        case .NowPlaying:
            managedMovies = cache.nowPlaying?.array as? [MovieMO]
        case .Popular:
            managedMovies = cache.popular?.array as? [MovieMO]
        case .TopRated:
            managedMovies = cache.topRated?.array as? [MovieMO]
        case .Upcoming:
            managedMovies = cache.upcoming?.array as? [MovieMO]
        }
        
        return managedMovies?.compactMap { $0.toMovie() } ?? []
        
    }
    
    func save(_ movies: [Movie]) {
        let cache = ManagedCache.uniqueInstance(in: store.context)
        let managedMovies = NSOrderedSet(array: movies.compactMap { MovieMO(withMovie: $0, context: store.context) })
        
        switch cacheList {
        case .NowPlaying:
            cache.addToNowPlaying(managedMovies)
        case .Popular:
            cache.addToPopular(managedMovies)
        case .TopRated:
            cache.addToTopRated(managedMovies)
        case .Upcoming:
            cache.addToUpcoming(managedMovies)
        }
        
        store.save()
    }
    
    func delete() {
        let cache = ManagedCache.uniqueInstance(in: store.context)
        
        switch cacheList {
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
        }
        
        store.save()
    }
    
}
