//
//  PersonCrewCredit.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

class PersonCrewCredit: Movie {
    var job: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        job <- map["job"]
    }
    
}
