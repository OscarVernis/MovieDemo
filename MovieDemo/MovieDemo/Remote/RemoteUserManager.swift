//
//  RemoteUserActionManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteUserManager {
    let sessionId: String?
    let service: MovieService
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
        self.service = MovieService(sessionId: sessionId)
    }
}

//MARK: - Actions
extension RemoteUserManager {
    func getUserDetails() -> AnyPublisher<User, Error> {
        let params = ["append_to_response": "favorite/movies,rated/movies,watchlist/movies"]
        
        return service.getModel(endpoint: .UserDetails, parameters: params)
    }
    
    func markAsFavorite(_ favorite: Bool, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)

        return service.successAction(endpoint: .MarkAsFavorite, body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)

        return service.successAction(endpoint: .AddToWatchlist, body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func rateMovie(_ rating: Float, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = ["value": rating]
        
        return service.successAction(endpoint: .RateMovie(movieId: movieId), body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func deleteRate(movieId: Int) -> AnyPublisher<Never, Error> {
        return service.successAction(endpoint: .DeleteRate(movieId: movieId), method: .delete)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
}
