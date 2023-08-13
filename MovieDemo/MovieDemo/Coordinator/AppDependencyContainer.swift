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
    
    lazy var urlSessionWithoutCache: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        return URLSession(configuration: config)
    }()
    
    var remoteClient: TMDBClient {
        TMDBClient(sessionId: sessionId, httpClient: URLSessionHTTPClient(session: urlSessionWithoutCache))
    }

    var isLoggedIn: Bool {
        sessionManager.isLoggedIn
    }
    
    var logoutService: LogoutService {
        sessionManager.logout
    }
    
    //MARK: - Helpers
    func moviesProvider(for movieList: MoviesEndpoint, cacheList: CodableCache<[Movie]>.CacheList? = nil) -> MoviesProvider {
        var cache: CodableCache<[Movie]>?
        if let cacheList {
            cache = CodableCache.cache(for: cacheList)
        }
        
        let remoteService = { [unowned self] (page: Int) in
            self.remoteClient.getMovies(endpoint: movieList, page: page)
                .map(\.movies)
                .eraseToAnyPublisher()
        }
        
        let serviceWithCache = {
            self.paginatedPublisher(remoteService($0), page: $0, withCache: cache)
                .map { $0.map(MovieViewModel.init) }
                .eraseToAnyPublisher()
        }
        
        return ItemProvider(service: serviceWithCache)
        
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
    
    func paginatedPublisher<Model: Codable>(_ main: AnyPublisher<[Model], Error>, page: Int, withCache cache: (any ModelCache<[Model]>)?) -> AnyPublisher<[Model], Error> {
        guard let cache else { return main }
        
        if page == 1 {
            return publisher(main, withCache: cache)
        }

        return main
            .eraseToAnyPublisher()
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
        let service = { self.remoteClient.getUserLists(page: $0)  }
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
