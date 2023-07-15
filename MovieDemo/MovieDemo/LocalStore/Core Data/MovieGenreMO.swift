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
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(withMovieGenre movieGenre: MovieGenre, context: NSManagedObjectContext) {
        super.init(entity: Self.entity(), insertInto: context)
        
        self.id = Int16(movieGenre.rawValue)
    }
    
    func toMovieGenre() -> MovieGenre? {
        return MovieGenre(rawValue: Int(id))
    }
}
