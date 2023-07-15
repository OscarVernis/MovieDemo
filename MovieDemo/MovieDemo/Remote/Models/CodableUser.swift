//
//  CodableUser.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

//MARK: - User
struct CodableUser: Codable {
    let avatar: Avatar?
    let id: Int?
    let username: String?

    let favoriteMovies, ratedMovies, watchlistMovies: ServiceModelsResult<CodableMovie>?

    enum CodingKeys: String, CodingKey {
        case avatar, id, username
        case favoriteMovies = "favorite/movies"
        case ratedMovies = "rated/movies"
        case watchlistMovies = "watchlist/movies"
    }
}

//MARK: - Avatar
struct Avatar: Codable {
    let gravatar: Gravatar?
}

//MARK: - Gravatar
struct Gravatar: Codable {
    let hash: String?
}

