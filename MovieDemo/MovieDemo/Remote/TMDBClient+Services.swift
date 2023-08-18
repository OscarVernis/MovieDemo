//
//  TMDBClient+Services.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

//MARK: - Movies
extension TMDBClient {
    func getMovies(endpoint: MoviesEndpoint,  page: Int) -> AnyPublisher<[Movie], Error> {
        let publisher: AnyPublisher<ServiceModelsResult<CodableMovie>, Error> = getModels(endpoint: .movies(endpoint), page: page)
        
        return publisher
            .map { $0.items.toMovies() }
            .eraseToAnyPublisher()
    }
    
}

//MARK: - Details
extension TMDBClient {
    func getMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        let params = ["append_to_response" : "credits,recommendations,account_states,videos,external_ids,watch/providers"]
        
        let publisher: AnyPublisher<CodableMovie, Error> = getModel(endpoint: .movieDetails(movieId: movieId), parameters: params)
        
        return publisher
            .map { $0.toMovie() }
            .eraseToAnyPublisher()
    }
    
    func getWatchProviders(movieId: Int) -> AnyPublisher<[Country: CountryWatchProviders], Error> {
        let publisher: AnyPublisher<CodableWatchProvidersResult, Error> = getModel(endpoint: .watchProviders(movieId: movieId))

        return publisher
            .map { $0.toWatchProviders() }
            .eraseToAnyPublisher()
    }
    
    func getPersonDetails(personId: Int) -> AnyPublisher<Person, Error> {
        let params = ["append_to_response": "movie_credits,external_ids"]
        
        let publisher: AnyPublisher<CodablePerson, Error> = getModel(endpoint: .personDetails(personId: personId), parameters: params)

        return publisher
            .map { $0.toPerson() }
            .eraseToAnyPublisher()
    }
    
    func getUserDetails() -> AnyPublisher<User, Error> {
         let params = ["append_to_response": "favorite/movies,rated/movies,watchlist/movies"]

        let publisher: AnyPublisher<CodableUser, Error> = getModel(endpoint: .userDetails, parameters: params)
        
        return publisher
            .map { $0.toUser() }
            .eraseToAnyPublisher()
     }
    
}

//MARK: - Search Service
extension TMDBClient {
    func search(query: String, page: Int = 1) -> AnyPublisher<[SearchResultItem], Error>  {
        let publisher: AnyPublisher<ServiceModelsResult<MediaItem>, Error> = getModels(endpoint: .search, parameters: ["query" : query], page: page)
        
        return publisher
            .map { $0.items.compactMap { $0.toSearchResultItem() } }
            .eraseToAnyPublisher()
    }
    
    func movieSearch(query: String, page: Int = 1) -> AnyPublisher<[Movie], Error>  {
        let publisher: AnyPublisher<ServiceModelsResult<CodableMovie>, Error> = getModels(endpoint: .movieSearch, parameters: ["query" : query], page: page)
        
        return publisher
            .map { $0.items.toMovies() }
            .eraseToAnyPublisher()
    }
}

//MARK: - UserState Service
extension TMDBClient: UserStateService {
    func markAsFavorite(_ favorite: Bool, movieId: Int) async throws {
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)
        
        let _ = try await successAction(endpoint: .markAsFavorite, body: body, method: .post).async()
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int) async throws {
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)
        
        let _ = try await successAction(endpoint: .addToWatchlist, body: body, method: .post).async()
    }
    
    func rateMovie(_ rating: Float, movieId: Int) async throws {
        let body = ["value": rating]
        
        let _ = try await successAction(endpoint: .rateMovie(movieId), body: body, method: .post).async()
    }
    
    func deleteRate(movieId: Int) async throws {
        let _ = try await successAction(endpoint: .deleteRate(movieId), method: .delete).async()
    }
    
}

//MARK: - Session Service
extension TMDBClient: SessionService {
    func requestToken() async throws -> String {
        let serviceResult: ServiceSuccessResult = try await successAction(endpoint: .requestToken).async()
        guard let token: String = serviceResult.requestToken else { throw TMDBClient.ServiceError.JsonError }
        
        return token
    }
    
    func validateToken(username: String, password: String, requestToken: String) async throws {
        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        let _: ServiceSuccessResult = try await successAction(endpoint: .validateToken, body: body, method: .post).async()
    }
    
    
    func createSession(requestToken: String) async throws -> String  {
        let body = ["request_token": requestToken]
        let serviceResult: ServiceSuccessResult = try await successAction(endpoint: .createSession, body: body, method: .post).async()
        
        guard let sessionId: String = serviceResult.sessionId else { throw TMDBClient.ServiceError.JsonError }
        
        return sessionId
    }
    
    func deleteSession(sessionId: String) async throws {
        let body = ["session_id": sessionId]
        
        let _: ServiceSuccessResult = try await successAction(endpoint: .deleteSession, body: body, method: .delete).async()
    }

}

//MARK: - UserLists Service
extension TMDBClient: UserListActionsService {
    func getUserLists(page: Int) -> AnyPublisher<UserListsResult, Error> {
        let publisher: AnyPublisher<ServiceModelsResult<CodableUserList>, Error> = getModels(endpoint: .userLists, page: page)
        
        return publisher
            .map { result in
                let lists = result.items.toUserLists()
                return UserListsResult(lists: lists, totalPages: result.totalPages)
            }
            .eraseToAnyPublisher()
    }
    
    func createList(name: String, description: String) async throws -> UserList {
        let body = CreateListRequestBody(name: name, description: description)
        let result = try await successAction(endpoint: .createList, body: body, method: .post).async()
        
        if let listId = result.listId {
            return UserList(id: listId, name: name, description: description)
        } else {
            throw ServiceError.JsonError
        }
    }
    
    func deleteList(listId: Int) async throws {
        //API sends error 500 but does delete the list
        let _ = try? await successAction(endpoint: .deleteList(listId), method: .delete).async()
    }
    
    func getUserListDetails(listId: Int) -> AnyPublisher<UserList, Error> {
        let publisher: AnyPublisher<CodableUserList, Error> = getModel(endpoint: .userListDetails(listId))
        
        return publisher
            .map { $0.toUserList() }
            .eraseToAnyPublisher()
    }
}

extension TMDBClient: UserDetailActionsService {
    func clearList(listId: Int) async throws {
        let params = ["confirm": "true"]

        let _ = try await successAction(endpoint: .clearList(listId), method: .post, parameters: params).async()
    }
    
    func addMovie(movieId: Int, toList listId: Int) async throws {
        let params = ["media_id": "\(movieId)"]
        
        let _ = try await successAction(endpoint: .addMovie(toList: listId), method: .post, parameters: params).async()
    }
    
    func removeMovie(movieId: Int, fromList listId: Int) async throws {
        let params = ["media_id": "\(movieId)"]
        
        let _ = try await successAction(endpoint: .removeMovie(toList: listId), method: .post, parameters: params).async()
    }
}
