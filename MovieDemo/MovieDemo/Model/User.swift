//
//  User.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class User: Codable {
    var avatar: String?
    var id: Int!
    var username: String!
    
    var favorites = [Movie]()
    var watchlist = [Movie]()
    var rated = [Movie]()
}
