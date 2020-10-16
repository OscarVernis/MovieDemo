//
//  Person.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

class Person: MediaItem {
    var id: Int!
    var name: String!
    var knownForDepartment: String?
    var birthday: Date?
    var deathday: Date?
    var gender: Int?
    var biography: String?
    var placeOfBirth: String?
    var profilePath: String?
    
    var castCredits: [PersonCastCredit]?
    var crewCredits: [PersonCrewCredit]?


    //MARK: - ObjectMapper
    override class func objectForMapping(map: Map) -> BaseMappable? {
        if map.JSON["id"] == nil {
            return nil
        }
        
        if map.JSON["name"] == nil {
            return nil
        }
        
        return Person()
    }

    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        knownForDepartment <- map["known_for_department"]
        birthday <- (map["birthday"], CustomDateFormatTransform(formatString: "yyyy-MM-dd"))
        deathday <- (map["deathday"], CustomDateFormatTransform(formatString: "yyyy-MM-dd"))
        gender <- map["gender"]
        biography <- map["biography"]
        placeOfBirth <- map["place_of_birth"]
        profilePath <- map["profile_path"]

        castCredits <- map["movie_credits.cast"]
        crewCredits <- map["movie_credits.crew"]
    }
    
}
