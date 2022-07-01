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
    var jsonDecoder = MovieService().jsonDecoder()
    
    init(filename: String) {
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: filename, withExtension: "json")!)
            let result = try jsonDecoder.decode(ServiceModelsResult<Movie>.self, from: data)
            movies = result.items
        } catch {
            fatalError("Couldn't load \(filename).json")
        }
    }
    
    func getMovies(movieList: MovieList, page: Int) -> AnyPublisher<MoviesResult, Error> {
        let result: MoviesResult = (movies: movies, totalPages: 1)
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    var viewModels: [MovieViewModel] {
        movies.map { MovieViewModel(movie: $0) }
    }
    
}
