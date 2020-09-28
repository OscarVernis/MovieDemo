//
//  MovieGenreDictionaryTransformer.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieGenreDictionaryTransformer: TransformType {
    typealias Object = MovieGenre
    typealias JSON = [String: Any]
    
    //Movie details returns as this: "genres": [{" id": 18, "name": "Drama" }]
    func transformFromJSON(_ value: Any?) -> MovieGenre? {
        if let genre = value as? [String: Any], let genreId = genre["id"] as? Int {
            return MovieGenre(rawValue: genreId)
        }
        
        return nil
    }
    
    func transformToJSON(_ value: MovieGenre?) -> [String: Any]? {
        return nil
    }
}
