//
//  CrewCredit+CoreDataClass.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/14/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//
//

import ObjectMapper

class CrewCredit: Mappable {
    var id: Int!
    var name: String!
    var creditId: Int?
    var department: String?
    var gender: Int?
    var job: String?
    var profilePath: String?
    
    //MARK: - ObjectMapper
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        
        if map.JSON["name"] == nil {
            return nil
        }
    }

    func mapping(map: Map) {
        creditId <- map["credit_id"]
        department <- map["department"]
        gender <- map["gender"]
        id <- map["id"]
        job <- map["job"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }
    
}

extension CrewCredit: Hashable {
   func hash(into hasher: inout Hasher) {
        hasher.combine(job)
        hasher.combine(creditId)
    }
}

extension CrewCredit: Equatable {
    static func == (lhs: CrewCredit, rhs: CrewCredit) -> Bool {
        return lhs.creditId == lhs.creditId
    }
    
}
