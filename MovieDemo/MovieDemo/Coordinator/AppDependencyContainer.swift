//
//  AppDependencyContainer.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit
import Combine

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
    
    var logoutService: LogoutService {
        sessionManager.logout
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
    
    func publisher<Model: Codable>(_ main: AnyPublisher<Model, Error>, withCache cache: any ModelCache<Model>) -> AnyPublisher<Model, Error> {
        //The resulting publisher loads from the cache first while the remote service completes and the caches the result from that service
        let mainWithCache = main
            .cache(with: cache)
        
        let cacheThenMain = cache.publisher
            .merge(with: mainWithCache)
            .eraseToAnyPublisher()
        
        return cacheThenMain
    }
    
    //MARK: - View Dependencies
    var searchProvider: SearchProvider {
        SearchProvider(searchService: remoteClient.search)
    }
    
    var loginViewStore: LoginViewStore {
        LoginViewStore(loginService: sessionManager)
    }
    
    var userProfileStore: UserProfileStore {
        let service = publisher(remoteClient.getUserDetails(), withCache: CodableCache.userCache)
        
        return UserProfileStore(service: service)
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
    
    var userListsDataStore: UserListsStore {
        let service = { self.remoteClient.getUserLists(userId: 8555334, page: $0)  }
        return UserListsStore(service: service, actionsService: remoteClient)
    }
    
    func userListDetailStore(list: UserList) -> UserListDetailStore {
        let service = { self.remoteClient.getUserListDetails(listId: list.id) }
        return UserListDetailStore(userList: list, service: service, actionsService: remoteClient)
    }
    
    //MARK: - Lists
    var recentMovies: [MovieViewModel] {
        MockData.movieVMs
    }
    
    var movieSearchService: (String) -> AnyPublisher<[MovieViewModel], Error> {
        { self.remoteClient.movieSearch(query: $0, page: 1)
            .map { $0.movies.map(MovieViewModel.init) }
            .eraseToAnyPublisher()
        }
    }
}
