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
    func getMovies(endpoint: MoviesEndpoint,  page: Int) -> AnyPublisher<MoviesResult, Error> {
        let publisher: AnyPublisher<ServiceModelsResult<Movie>, Error> = getModels(endpoint: .movies(endpoint), page: page)
        
        return publisher
            .map { result in
                MoviesResult(movies: result.items, totalPages: result.totalPages)
            }
            .eraseToAnyPublisher()
    }
    
}

//MARK: - Details
extension TMDBClient {
    func getMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        let params = ["append_to_response" : "credits,recommendations,account_states,videos"]
        
        return getModel(endpoint: .movieDetails(movieId: movieId), parameters: params)
    }
    
    func getPersonDetails(personId: Int) -> AnyPublisher<Person, Error> {
        let params = ["append_to_response": "movie_credits"]
        
        return getModel(endpoint: .personDetails(personId: personId), parameters: params)
    }
    
    func getUserDetails() -> AnyPublisher<User, Error> {
         let params = ["append_to_response": "favorite/movies,rated/movies,watchlist/movies"]

         return getModel(endpoint: .userDetails, parameters: params)
     }
    
}

//MARK: - Search Service
extension TMDBClient {
    func search(query: String, page: Int = 1) -> AnyPublisher<SearchResult, Error>  {
        let publisher: AnyPublisher<ServiceModelsResult<MediaItem>, Error> = getModels(endpoint: .search, parameters: ["query" : query], page: page)
        
        return publisher
            .compactMap { result in
                let searchResults: [Any] = result.items.compactMap { item -> Any? in
                    switch item {
                    case .person(let person):
                        return person
                    case .movie(let movie):
                        return movie
                    case .unknown:
                        return nil
                    }
                }
                
                return (searchResults, result.totalPages)
            }
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
    
    func deleteSession(sessionId: String) async throws -> Result<Void, Error> {
        let body = ["session_id": sessionId]
        
        let result = try await successAction(endpoint: .deleteSession, body: body, method: .delete).async()
        if let success = result.success, success == true {
            return .success(())
        } else {
            return .failure(TMDBClient.ServiceError.NoSuccess)
        }
    }

}
