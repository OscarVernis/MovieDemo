//
//  MovieVideo.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import ObjectMapper

class MovieVideo: Mappable  {
    var key: String!
    var name: String?
    
    //MARK: - ObjectMapper
    required init?(map: Map) {
        if map.JSON["key"] == nil {
            return nil
        }
        
        if map.JSON["site"] as? String != "YouTube" {
            return nil
        }
        
        if map.JSON["type"] as? String != "Trailer" {
            return nil
        }
    }

    func mapping(map: Map) {
        key <- map["key"]
        name <- map["name"]
    }
}
