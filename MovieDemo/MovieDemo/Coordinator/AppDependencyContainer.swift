//
//  AppDependencyContainer.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

class AppDependencyContainer {
    init(sessionManager: SessionManager? = nil) {
        if let sessionManager {
            self.sessionManager = sessionManager
        }
    }
    
    //MARK: - Global dependencies
    var sessionManager =  SessionManager(service: TMDBClient(), store: KeychainSessionStore())
    
    private var sessionId: String? {
        sessionManager.sessionId
    }
    
    var remoteClient: TMDBClient {
        TMDBClient(sessionId: sessionId, httpClient: URLSessionHTTPClient())
    }

    var isLoggedIn: Bool {
        sessionManager.isLoggedIn
    }
    
    //MARK: - Helpers
    func moviesProvider(for movieList: MoviesEndpoint, cacheList: CodableCache<[Movie]>.CacheList? = nil) -> MoviesProvider {
        var cache: (any ModelCache<[Movie]>)? = nil
        if let cacheList {
            cache = CodableCache.cache(for: cacheList)
        }
        
        let service = { [unowned self] (page: Int) in
            self.remoteClient.getMovies(endpoint: movieList, page: page)
        }
        
        return MoviesProvider(service: service, cache: cache)
    }
    
    //MARK: - View Dependencies
    var searchProvider: SearchProvider {
        SearchProvider(searchService: remoteClient.search)
    }
    
    var loginViewStore: LoginViewStore {
        LoginViewStore(loginService: sessionManager)
    }
    
    var userProfileStore: UserProfileStore {
        //The resulting publisher loads from the cache first while the remote service completes and the caches the result from that service
        let cache = CodableCache.userCache
        let remoteWithCache = remoteClient.getUserDetails()
            .cache(with: cache)
        
        let cacheThenRemote = cache.publisher
            .merge(with: remoteWithCache)
            .eraseToAnyPublisher()
        
        return UserProfileStore(service: cacheThenRemote)
    }
    
    func movieDetailsStore(movie: MovieViewModel) -> MovieDetailStore {
        let movieService = remoteClient.getMovieDetails(movieId: movie.id)
        let userStateService: UserStateService? = isLoggedIn ? remoteClient : nil

        return MovieDetailStore(movie: movie,
                                     movieService: movieService,
                                     userStateService: userStateService)
    }
    
    func personDetailStore(person: PersonViewModel) -> PersonDetailStore {
        let service = remoteClient.getPersonDetails(personId: person.id)
        return PersonDetailStore(person: person, service: service)
    }
    
}
