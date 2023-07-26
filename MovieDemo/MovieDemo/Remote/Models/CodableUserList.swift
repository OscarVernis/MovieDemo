//
//  CodableUserList.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

struct CodableUserList: Codable {
    let id: Int!
    let name: String!
    let description: String?
    let favoriteCount: Int?
    let itemCount: Int?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case favoriteCount = "favorite_count"
        case itemCount = "item_count"
        case posterPath = "poster_path"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try? container.decodeIfPresent(String.self, forKey: .description)
        self.favoriteCount = try? container.decodeIfPresent(Int.self, forKey: .favoriteCount)
        self.itemCount = try? container.decodeIfPresent(Int.self, forKey: .itemCount)
        self.posterPath = try? container.decodeIfPresent(String.self, forKey: .posterPath)
    }
    
}
