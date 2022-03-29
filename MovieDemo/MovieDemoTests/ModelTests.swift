//
//  ModelTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 22/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class ModelTests: XCTestCase {

    func test_MovieModel_Detail() throws {
        var movieData = Data()
        XCTAssertNoThrow( movieData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Movie", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var movie = Movie()
        XCTAssertNoThrow( movie = try decoder.decode(Movie.self, from: movieData) )
        
        XCTAssertEqual(movie.id, 155)
        XCTAssertEqual(movie.title, "The Dark Knight")
        XCTAssertEqual(movie.productionCountries, ["GB", "US"])
        XCTAssertEqual(movie.genres, [.Drama, .Action, .Crime, .Thriller])
        XCTAssertEqual(movie.videos?.count, 7)
        XCTAssertEqual(movie.recommendedMovies?.count, 21)
        XCTAssertEqual(movie.cast?.count, 134)
        XCTAssertEqual(movie.crew?.count, 112)
        XCTAssertEqual(movie.favorite, true)
        XCTAssertEqual(movie.watchlist, false)
        XCTAssertEqual(movie.userRating, 8.5)
    }
    
    func test_MovieModel_NoRating() throws {
        var movieData = Data()
        XCTAssertNoThrow( movieData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Movie_NoRating", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var movie = Movie()
        XCTAssertNoThrow( movie = try decoder.decode(Movie.self, from: movieData) )
        
        XCTAssertEqual(movie.id, 414906)
        XCTAssertEqual(movie.title, "The Batman")
        XCTAssertNil(movie.userRating)
    }
    
    func test_MovieModel_FromList() throws {
        var movieData = Data()
        XCTAssertNoThrow( movieData = try Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Movies", withExtension: "json")!) )
        
        let decoder = jsonDecoder()
        var movie = Movie()
        XCTAssertNoThrow( movie = try decoder.decode(ServiceModelsResult<Movie>.self, from: movieData).results.first! )
        
        XCTAssertEqual(movie.id, 297761)
        XCTAssertEqual(movie.title, "Suicide Squad")
        XCTAssertEqual(movie.genres, [.Fantasy, .Action, .Crime])
    }
    
    //MARK: - Helpers
    func jsonDecoder(dateFormat: String = "yyyy-MM-dd", keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }

}
