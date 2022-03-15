//
//  MovieGenreMO.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MovieGenreMO)
public class MovieGenreMO: NSManagedObject {
    class func from(movieGenre: MovieGenre) -> MovieGenreMO {
        let movieGenreMO = MovieGenreMO()
        movieGenreMO.id = Int16(movieGenre.rawValue)
        
        return movieGenreMO
    }
    
    func toMovieGenre() -> MovieGenre? {
        return MovieGenre(rawValue: Int(id))
    }
}
