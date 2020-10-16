//
//  MediaItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

class MediaItem: StaticMappable {
    init() {
        
    }
    
    class func objectForMapping(map: Map) -> BaseMappable? {
        if let type: String = map["media_type"].value() {
                    switch type {
                        case "movie":
                            return Movie()
                        case "person":
                            return Person()
                        default:
                            return nil
                    }
                }
                return nil
    }
    
    func mapping(map: Map) {
    }
    
}
