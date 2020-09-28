//
//  MovieUserRatedTransform.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 23/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieUserRatedTransform: TransformType {
    typealias Object = Bool
    typealias JSON = Any
    
    //Service returns false if not rated, and the value of the rating if rated.
    func transformFromJSON(_ value: Any?) -> Bool? {
        if let rated = value as? Bool, rated == false {
            return false
        }
        
        if let rated = value as? [String: Any], let _ = rated["value"] as? Float {
            return true
        }
        
        return nil
    }
    
    func transformToJSON(_ value: Bool?) -> Any? {
        return nil
    }
}
