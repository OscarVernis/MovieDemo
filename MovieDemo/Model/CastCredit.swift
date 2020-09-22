//
//  Credit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import ObjectMapper

class CastCredit: Mappable {
    var name: String!
    var castId: Int?
    var character: String?
    var creditId: Int?
    var gender: Int?
    var id: Int?
    var order: Int?
    var profilePath: String?
    
    //MARK: - ObjectMapper
    required init?(map: Map) {
        if map.JSON["name"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        castId <- map["cast_id"]
        creditId <- map["credit_id"]
        gender <- map["gender"]
        id <- map["id"]
        order <- map["order"]
        character <- map["character"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
    
}

extension CastCredit: Hashable {
   func hash(into hasher: inout Hasher) {
        hasher.combine(creditId)
        hasher.combine(order)
    }
}

extension CastCredit: Equatable {
    static func == (lhs: CastCredit, rhs: CastCredit) -> Bool {
        return lhs.creditId == lhs.creditId
    }
    
}
