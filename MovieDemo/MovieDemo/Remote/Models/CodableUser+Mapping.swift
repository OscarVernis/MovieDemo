//
//  CodableUser+Mapping.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension CodableUser {
    func toUser() -> User {
        var user = User()
        
        user.avatar = avatar?.gravatar?.hash
        user.id = id
        user.username = username
        
        user.favorites = favoriteMovies?.items.compactMap { $0.toMovie() } ?? []
        user.watchlist = watchlistMovies?.items.compactMap { $0.toMovie() } ?? []
        user.rated = ratedMovies?.items.compactMap { $0.toMovie() } ?? []
        
        return user
    }
    
}
