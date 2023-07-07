//
//  UserStateService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol UserStateService {
    func markAsFavorite(_ favorite: Bool, movieId: Int) async throws
    
    func addToWatchlist(_ watchlist: Bool, movieId: Int) async throws
    
    func rateMovie(_ rating: Float, movieId: Int) async throws
    
    func deleteRate(movieId: Int) async throws
}
