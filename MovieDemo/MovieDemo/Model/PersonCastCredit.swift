//
//  PersonCastCredit.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

class PersonCastCredit: Movie {
    var character: String?
    
    override class func objectForMapping(map: Map) -> BaseMappable? {
        return PersonCastCredit()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        character <- map["character"]
    }
    
}
