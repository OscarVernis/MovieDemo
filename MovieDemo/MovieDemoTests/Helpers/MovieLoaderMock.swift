//
//  MovieLoaderMock.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 06/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine
@testable import MovieDemo

class MovieLoaderMock: MovieLoader {
    var pageCount: Int
    var movies: [Movie]
    var error: Error?
    
    init(movies: [Movie] = [], pageCount: Int = 1, error: Error? = nil) {
        self.pageCount = pageCount
        self.movies = movies
        self.error = error
    }
    
    func getMovies(movieList: MovieList, page: Int) -> AnyPublisher<([Movie], Int), Error> {
        if let error = error {
            return Fail(outputType: ([Movie], Int).self, failure: error)
                .eraseToAnyPublisher()
        }
        
        return Just( (movies, pageCount) )
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
