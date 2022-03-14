//
//  RemoteUserActionManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct RemoteUserManager {
    let service = MovieDBService()
    
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
    
    func getUserDetails(sessionId: String, completion: @escaping (Result<User, Error>) -> ()) {
        let url = service.endpoint(forPath: "/account/id")
        var params = service.defaultParameters(withSessionId: sessionId)
        params["append_to_response"] = "favorite/movies,rated/movies,watchlist/movies"
        
        service.getModel(url: url, params: params, completion: completion)
    }
    
    func getUserFavorites(sessionId: String, page: Int = 1, completion: @escaping MovieLoader.MovieListCompletion) {
        service.getModels(endpoint: "/account/id/favorite/movies", sessionId: sessionId, page: page, completion: completion)
    }
    
    func getUserWatchlist(sessionId: String, page: Int = 1, completion: @escaping MovieLoader.MovieListCompletion) {
        service.getModels(endpoint: "/account/id/watchlist/movies", sessionId: sessionId, page: page, completion: completion)
    }
    
    func getUserRatedMovies(sessionId: String, page: Int = 1, completion: @escaping MovieLoader.MovieListCompletion) {
        service.getModels(endpoint: "/account/id/rated/movies", sessionId: sessionId, page: page, completion: completion)
    }
    
    func markAsFavorite(_ favorite: Bool, movieId: Int, sessionId: String, completion: @escaping MovieDBService.SuccessActionCompletion) {
        let url = service.endpoint(forPath: "/account/id/favorite")
        let params = service.defaultParameters(withSessionId: sessionId)
        
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)

        service.successAction(url: url, params: params, body: body, method: .post, completion: completion)
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int, sessionId: String, completion: @escaping MovieDBService.SuccessActionCompletion) {
        let url = service.endpoint(forPath: "/account/id/watchlist")
        let params = service.defaultParameters(withSessionId: sessionId)
        
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)

        service.successAction(url: url, params: params, body: body, method: .post, completion: completion)
    }
    
    func rateMovie(_ rating: Float, movieId: Int, sessionId: String, completion: @escaping MovieDBService.SuccessActionCompletion) {
        let url = service.endpoint(forPath: "/movie/\(movieId)/rating")
        let params = service.defaultParameters(withSessionId: sessionId)
        
        let body = ["value": rating]

        service.successAction(url: url, params: params, body: body, method: .post, completion: completion)
    }
    
    func deleteRate(movieId: Int, sessionId: String, completion: @escaping MovieDBService.SuccessActionCompletion) {
        let url = service.endpoint(forPath: "/movie/\(movieId)/rating")
        let params = service.defaultParameters(withSessionId: sessionId)
            
        service.successAction(url: url, params: params, method: .delete, completion: completion)
    }
}
