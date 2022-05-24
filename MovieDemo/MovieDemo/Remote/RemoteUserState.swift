//
//  RemoteUserState.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteUserState {
    let sessionId: String?
    let service: MovieService
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
        self.service = MovieService(sessionId: sessionId)
    }
}

//MARK: - Actions
extension RemoteUserState {    
    func markAsFavorite(_ favorite: Bool, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)

        return service.successAction(endpoint: UserEndpoint.MarkAsFavorite, body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)

        return service.successAction(endpoint: UserEndpoint.AddToWatchlist, body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func rateMovie(_ rating: Float, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = ["value": rating]
        
        return service.successAction(endpoint: UserEndpoint.RateMovie(movieId: movieId), body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func deleteRate(movieId: Int) -> AnyPublisher<Never, Error> {
        return service.successAction(endpoint: UserEndpoint.DeleteRate(movieId: movieId), method: .delete)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
}
