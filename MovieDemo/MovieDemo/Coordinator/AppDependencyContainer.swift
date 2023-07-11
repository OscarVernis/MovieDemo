//
//  AppDependencyContainer.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

class AppDependencyContainer {
    //MARK: - Global dependencies
    var sessionManager =  SessionManager(service: TMDBClient(), store: KeychainSessionStore())
    private var sessionId: String? {
        sessionManager.sessionId
    }
    
    var remoteClient: TMDBClient {
        TMDBClient(sessionId: sessionId, httpClient: URLSessionHTTPClient())
    }
    
    var sessionService: SessionService {
        remoteClient
    }
    
    var isLoggedIn: Bool {
        sessionManager.isLoggedIn
    }
    
    var userCache: any ModelCache<User> {
        UserCache()
    }
    
    //MARK: - Helpers
    func moviesProvider(for movieList: MoviesEndpoint, cacheList: MovieCache.CacheList? = nil) -> MoviesProvider {
        let loader = RemoteMoviesLoader(movieList: movieList, sessionId: sessionId)
        
        var cache: MovieCache? = nil
        if let cacheList {
            cache = MovieCache(cacheList: cacheList)
        }
        
        return MoviesProvider(movieLoader: loader, cache: cache)
    }
    
    //MARK: - View Dependencies
    var searchProvider: SearchProvider {
        SearchProvider(searchLoader: remoteClient)
    }
    
    var loginViewStore: LoginViewStore {
        LoginViewStore(sessionManager: sessionManager)
    }
    
    var userProfileStore: UserProfileStore {
        let cache = UserCache()
        let service = remoteClient.getUserDetails()
            .cache(with: cache)
            .placeholder(with: cache.publisher)
        
        return UserProfileStore(service: service)
    }
    
    func movieDetailsStore(movie: MovieViewModel) -> MovieDetailStore {
        let movieService = remoteClient.getMovieDetails(movieId: movie.id)
        let userStateService: UserStateService? = isLoggedIn ? remoteClient : nil

        return MovieDetailStore(movie: movie,
                                     movieService: movieService,
                                     userStateService: userStateService)
    }
    
    func personDetailStore(_ viewModel: PersonViewModel) -> PersonDetailStore {
        let service = remoteClient.getPersonDetails(personId: viewModel.id)
        return PersonDetailStore(person: viewModel, service: service)
    }
    
}
