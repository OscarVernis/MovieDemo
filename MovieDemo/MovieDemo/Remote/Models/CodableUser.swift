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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        avatar = try? container.decode(Avatar.self, forKey: .avatar)
        favoriteMovies = try? container.decode( ServiceModelsResult<CodableMovie>.self, forKey: .favoriteMovies)
        ratedMovies = try? container.decode( ServiceModelsResult<CodableMovie>.self, forKey: .ratedMovies)
        watchlistMovies = try? container.decode( ServiceModelsResult<CodableMovie>.self, forKey: .watchlistMovies)
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

