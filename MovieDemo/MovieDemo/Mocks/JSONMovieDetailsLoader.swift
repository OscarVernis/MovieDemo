//
//  JSONMovieDetailsLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct JSONMovieDetailsLoader: MovieDetailsLoader {
    var movie: Movie = Movie()
    var jsonDecoder = MovieDecoder()
    
    private var error: Error?
    
    var viewModel: MovieViewModel {
        MovieViewModel(movie: movie)
    }

    init(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            error = NSError(domain: "Wrong filename!", code: 0)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            movie = try jsonDecoder.decode(Movie.self, from: data)
        } catch let jsonError {
            error = jsonError
        }
    }
    
    func getMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        if let error = error {
            return Fail(outputType: Movie.self, failure: error)
                .eraseToAnyPublisher()
        }
        
        return Just(movie)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
