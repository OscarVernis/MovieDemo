//
//  XCTestCase+AwaitPublisher.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 22/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
import Combine
@testable import MovieDemo

extension XCTestCase {
    func anyMovie() -> Movie {
        var movieData = Data()
        XCTAssertNoThrow( movieData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Movie", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var movie = Movie()
        XCTAssertNoThrow( movie = try decoder.decode(Movie.self, from: movieData) )
        
        return movie
    }
    
    func anyMovieVM() -> MovieViewModel {
        return MovieViewModel(movie: anyMovie())
    }
    
    func anyPerson() -> Person {
        var personData = Data()
        XCTAssertNoThrow( personData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Person", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var person = Person()
        XCTAssertNoThrow( person = try decoder.decode(Person.self, from: personData) )
        
        return person
    }
    
    func anyPersonVM() -> PersonViewModel {
        return PersonViewModel(person: anyPerson())
    }
    
    func anyMovies(count: Int) -> [Movie] {
        var movies = [Movie]()
        
        for _ in 0..<count {
            movies.append(anyMovie())
        }
        
        return movies
    }
    
    func jsonDecoder(dateFormat: String = "yyyy-MM-dd", keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
