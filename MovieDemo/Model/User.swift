//
//  User.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import ObjectMapper

// MARK: - User
class User: Mappable {
    var avatar: String?
    var id: Int!
    var username: String!
    
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
    }
}
