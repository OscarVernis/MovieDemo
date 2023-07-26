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
}

extension UserList: Equatable, Hashable { }
