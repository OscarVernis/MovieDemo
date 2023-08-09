//
//  UserList.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

struct UserList {
    let id: Int
    let name: String
    let description: String
    let favoriteCount: Int
    let itemCount: Int
    let posterPath: String?
    var movies: [Movie]
    
    init(id: Int, name: String, description: String = "", favoriteCount: Int = 0, itemCount: Int = 0, posterPath: String? = nil, movies: [Movie] = []) {
        self.id = id
        self.name = name
        self.description = description
        self.favoriteCount = favoriteCount
        self.itemCount = itemCount
        self.posterPath = posterPath
        self.movies = movies
    }
}

extension UserList: Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: UserList, rhs: UserList) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
