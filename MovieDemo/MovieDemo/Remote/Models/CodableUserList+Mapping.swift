//
//  CodableUserList+Mapping.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

extension CodableUserList {
    func toUserList() -> UserList {
        UserList(
            id: id,
            name: name ?? "",
            description: description ?? "",
            favoriteCount: favoriteCount ?? 0,
            itemCount: itemCount ?? 0,
            posterPath: posterPath,
            movies: items?.toMovies() ?? []
        )
    }
    
}

extension Collection where Element == CodableUserList {
    func toUserLists() -> [UserList] {
        map { $0.toUserList() }
    }
}
