//
//  Credit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import ObjectMapper

public class CastCredit: Mappable {
    var castId: Int?
    var character: String?
    var creditId: Int?
    var gender: Int?
    var id: Int?
    var name: String?
    var order: Int?
    var profilePath: String?
    
    //MARK: - ObjectMapper
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
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
