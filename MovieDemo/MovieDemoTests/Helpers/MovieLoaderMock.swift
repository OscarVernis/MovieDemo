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

class MovieLoaderMock {
    var pageCount: Int
    var movies: [Movie]
    var error: Error?
    
    init(movies: [Movie] = [], pageCount: Int = 1, error: Error? = nil) {
        self.pageCount = pageCount
        self.movies = movies
        self.error = error
    }
    
    func getMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        if let error = error {
            return Fail(outputType: [Movie].self, failure: error)
                .eraseToAnyPublisher()
        }
        
        let resultMovies = page <= pageCount ? movies : [Movie]()
        return Just(resultMovies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getViewModels(page: Int) -> AnyPublisher<[MovieViewModel], Error> {
        return getMovies(page: page)
            .map { $0.map(MovieViewModel.init) }
            .eraseToAnyPublisher()
    }
    
}
