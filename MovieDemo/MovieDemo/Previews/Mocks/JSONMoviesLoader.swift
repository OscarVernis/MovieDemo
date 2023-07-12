//
//  JSONMoviesLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct JSONMoviesLoader {
    var movies: [Movie] = []
    var jsonDecoder = MovieDecoder()
    
    private var error: Error?
    
    var viewModels: [MovieViewModel] {
        movies.map { MovieViewModel(movie: $0) }
    }
    
    init(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            error = NSError(domain: "Wrong filename!", code: 0)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try jsonDecoder.decode(ServiceModelsResult<Movie>.self, from: data)
            movies = result.items
        } catch let jsonError {
            error = jsonError
        }
    }
    
    func getMovies(page: Int = 0) -> AnyPublisher<MoviesResult, Error> {
        if let error = error {
            return Fail(outputType: MoviesResult.self, failure: error)
                .eraseToAnyPublisher()
        }

        let result: MoviesResult = (movies: movies, totalPages: 1)
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
