//
//  CrewCredit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import ObjectMapper

public class CrewCredit: Mappable {
    var creditId: Int?
    var department: String?
    var gender: Int?
    var id: Int?
    var job: String?
    var name: String?
    var profilePath: String?
    
    //MARK: - ObjectMapper
    
    public required init?(map: Map) {
        
    }

    public func mapping(map: Map) {
        creditId <- map["credit_id"]
        department <- map["department"]
        gender <- map["gender"]
        id <- map["id"]
        job <- map["job"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
    
}
