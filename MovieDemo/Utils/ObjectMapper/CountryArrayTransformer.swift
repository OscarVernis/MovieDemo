//
//  CountryArrayTransformer.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

class CountryArrayTransformer: TransformType {
    typealias Object = String
    typealias JSON = [String: String]
    
    func transformFromJSON(_ value: Any?) -> String? {
        guard let country = value as? [String: String], let name = country["iso_3166_1"] else { return nil }
        
        return name
    }
    
    func transformToJSON(_ value: String?) -> [String: String]? {
        return nil
    }
    
}

