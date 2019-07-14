//
//  CrewCredit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import Alamofire
import MagicalRecord
import ObjectMapper

@objc(CrewCredit)
public class CrewCredit: MappableManagedObject {
    
    //MARK: - ObjectMapper

    public override func mapping(map: Map) {
        creditId <- map["credit_id"]
        department <- map["department"]
        gender <- map["gender"]
        id <- map["id"]
        job <- map["job"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
}
