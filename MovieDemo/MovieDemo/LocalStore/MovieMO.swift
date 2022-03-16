//
//  MovieMO.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MovieMO)
public class MovieMO: NSManagedObject {
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(withMovie movie: Movie, context: NSManagedObjectContext) {
        super.init(entity: Self.entity(), insertInto: context)
        
        self.id = Int64(movie.id)
        self.title = "CD_" + movie.title
        self.backdropPath = movie.backdropPath
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.popularity = movie.popularity ?? 0
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage ?? 0
        self.voteCount = Int64(movie.voteCount ?? 0)
        
        if let genres = movie.genres?.compactMap({ MovieGenreMO(withMovieGenre: $0, context: context) }) {
            self.addToGenres(NSOrderedSet(array: genres))
        }
    }
    
    func toMovie() -> Movie {
        var movie = Movie()
        
        movie.id = Int(id)
        movie.title = title
        movie.backdropPath = backdropPath
        movie.originalTitle = originalTitle
        movie.overview = overview
        movie.popularity = popularity
        movie.posterPath = posterPath
        movie.releaseDate = releaseDate
        movie.voteAverage = voteAverage
        movie.voteCount = Int(voteCount)

        if let movieGenres = genres?.array as? [MovieGenreMO] {
            movie.genres = movieGenres.compactMap { $0.toMovieGenre() }
        }
        
        return movie
    }

}
