//
//  User.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    var avatar: String?
    var id: Int!
    var username: String!
    
    var favorites = [Movie]()
    var watchlist = [Movie]()
    var rated = [Movie]()

    
    //MARK: - ObjectMapper
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        
        if map.JSON["username"] == nil {
            return nil
        }
    }

    func mapping(map: Map) {
        avatar <- map["avatar.gravatar.hash"]
        id <- map["id"]
        username <- map["username"]
        
        favorites <- map["favorite/movies.results"]
        watchlist <- map["watchlist/movies.results"]
        rated <- map["rated/movies.results"]
    }
}
