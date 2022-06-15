//
//  JSONMovieLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct JSONMovieLoader: MovieLoader {
    var movies: [Movie] = []
    var error: Error?
    
    init(filename: String) {
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: filename, withExtension: "json")!)
            let result = try JSONDecoder().decode(ServiceModelsResult<Movie>.self, from: data)
            movies = result.items
        } catch(let jsonError) {
            print(jsonError)
            error = UserFacingError.refreshError
        }
    }
    
    func getMovies(movieList: MovieList, page: Int) -> AnyPublisher<MoviesResult, Error> {
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        let result: MoviesResult = (movies: movies, totalPages: 1)
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
