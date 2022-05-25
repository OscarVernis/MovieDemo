//
//  User.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct User {
    var avatar: String?
    var id: Int!
    var username: String!
    
    var favorites = [Movie]()
    var watchlist = [Movie]()
    var rated = [Movie]()
}

//MARK: - Codable
extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case username
        case favorites = "favorite/movies"
        case watchlist = "watchlist/movies"
        case rated = "rated/movies"
    }
    
    enum NestedKeys: String, CodingKey {
        case gravatar
    }
    
    enum SpecialKeys: String, CodingKey {
        case hash
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        
        let favoritesResults = try? container.decodeIfPresent(ServiceModelsResult<Movie>.self, forKey: .favorites)
        favorites = favoritesResults?.items ?? [Movie]()
        
        let watchListResults = try? container.decodeIfPresent(ServiceModelsResult<Movie>.self, forKey: .watchlist)
        watchlist = watchListResults?.items ?? [Movie]()

        let ratedResults = try? container.decodeIfPresent(ServiceModelsResult<Movie>.self, forKey: .rated)
        rated = ratedResults?.items ?? [Movie]()

        let avatarContainer = try? container.nestedContainer(keyedBy: NestedKeys.self, forKey: .avatar)
        let gravatarContainer = try? avatarContainer?.nestedContainer(keyedBy: SpecialKeys.self, forKey: .gravatar)
        avatar = try? gravatarContainer?.decodeIfPresent(String.self, forKey: .hash)
    }
}
