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
    let movie: Movie
    var jsonDecoder = MovieDecoder()
    
    var viewModel: MovieViewModel {
        MovieViewModel(movie: movie)
    }

    init(filename: String) {
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: filename, withExtension: "json")!)
            movie = try jsonDecoder.decode(Movie.self, from: data)
        } catch {
            fatalError("Couldn't load \(filename).json")
        }
    }
    
    func getMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        Just(movie)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
