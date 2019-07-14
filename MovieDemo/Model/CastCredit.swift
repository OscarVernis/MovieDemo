//
//  Credit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Alamofire
import MagicalRecord
import ObjectMapper

@objc(CastCredit)
public class CastCredit: MappableManagedObject {

    //MARK: - ObjectMapper
    
    public override func mapping(map: Map) {
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
