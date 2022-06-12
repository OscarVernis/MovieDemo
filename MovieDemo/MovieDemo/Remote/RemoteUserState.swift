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
    let sessionId: String
    let service: MovieService
    
    init(sessionId: String) {
        self.sessionId = sessionId
        self.service = MovieService(sessionId: sessionId)
    }
}

//MARK: - Actions
extension RemoteUserState {    
    func markAsFavorite(_ favorite: Bool, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)

        return service.successAction(endpoint: .markAsFavorite, body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)

        return service.successAction(endpoint: .addToWatchlist, body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func rateMovie(_ rating: Float, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = ["value": rating]
        
        return service.successAction(endpoint: .rateMovie(movieId), body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func deleteRate(movieId: Int) -> AnyPublisher<Never, Error> {
        return service.successAction(endpoint: .deleteRate(movieId), method: .delete)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
}
