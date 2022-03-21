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
    let service: MovieDBService
    
    init(sessionId: String? = nil) {
        self.sessionId = sessionId
        self.service = MovieDBService(sessionId: sessionId)
    }
    
    private struct FavoriteRequestBody: Encodable {
        var media_type: String = "movie"
        var media_id: Int
        var favorite: Bool
    }
    
    private struct WatchlistRequestBody: Encodable {
        var media_type: String = "movie"
        var media_id: Int
        var watchlist: Bool
    }
    
    func getUserDetails() -> AnyPublisher<User, Error> {
        let params = ["append_to_response": "favorite/movies,rated/movies,watchlist/movies"]
        
        return service.getModel(path: "/account/id", parameters: params)
    }
    
    func markAsFavorite(_ favorite: Bool, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)

        return service.successAction(path: "/account/id/favorite", body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)

        return service.successAction(path: "/account/id/watchlist", body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func rateMovie(_ rating: Float, movieId: Int) -> AnyPublisher<Never, Error> {
        let body = ["value": rating]
        
        return service.successAction(path: "/movie/\(movieId)/rating", body: body, method: .post)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    func deleteRate(movieId: Int) -> AnyPublisher<Never, Error> {
        return service.successAction(path: "/movie/\(movieId)/rating", method: .delete)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
}
