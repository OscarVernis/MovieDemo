//
//  MovieGenreTransformer.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieGenreTransformer: TransformType {
    typealias Object = MovieGenre
    typealias JSON = Int
    
    //Movie lists return genres as this: "genre_ids": [14, 28, 80]
    func transformFromJSON(_ value: Any?) -> MovieGenre? {
        if let genreId = value as? Int {
            return MovieGenre(rawValue: genreId)
        }
        
        return nil
    }
    
    func transformToJSON(_ value: MovieGenre?) -> Int? {
        return value?.rawValue
    }
}
