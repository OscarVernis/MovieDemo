//
//  MovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine


typealias MovieList = MoviesEndpoint
typealias MoviesResult = (movies: [Movie], totalPages: Int)

protocol MovieLoader {    
    func getMovies(movieList: MovieList, page: Int) -> AnyPublisher<MoviesResult, Error>
}
