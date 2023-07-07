//
//  RemoteUserStateService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteUserStateService {
    let sessionId: String
    let service: MovieService
    
    init(sessionId: String) {
        self.sessionId = sessionId
        self.service = MovieService(sessionId: sessionId)
    }
}

//MARK: - Actions
extension RemoteUserStateService: UserStateService {
    func markAsFavorite(_ favorite: Bool, movieId: Int) async throws {
        let body = FavoriteRequestBody(media_id: movieId, favorite: favorite)
        
        let _ = try await service.successAction(endpoint: .markAsFavorite, body: body, method: .post).async()
    }
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int) async throws {
        let body = WatchlistRequestBody(media_id: movieId, watchlist: watchlist)
        
        let _ = try await service.successAction(endpoint: .addToWatchlist, body: body, method: .post).async()
    }
    
    func rateMovie(_ rating: Float, movieId: Int) async throws {
        let body = ["value": rating]
        
        let _ = try await service.successAction(endpoint: .rateMovie(movieId), body: body, method: .post).async()
    }
    
    func deleteRate(movieId: Int) async throws {
        let _ = try await service.successAction(endpoint: .deleteRate(movieId), method: .delete).async()
    }
    
}
