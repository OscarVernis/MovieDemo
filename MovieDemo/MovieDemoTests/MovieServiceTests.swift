//
//  MovieServiceTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class MovieServiceTests: XCTestCase {
    
    func test_getModel_success() {
        let movieId = 155
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)")!
        let mocker = MockData(jsonFile: "Movie", url: url)
        
        let sut = MovieService(session: mocker.session)
        var movie = Movie()
        
        XCTAssertNoThrow(movie = try awaitPublisher( sut.getModel(endpoint: .MovieDetails(movieId: movieId)) ))
        
        XCTAssertEqual(movie.id, movieId)
        XCTAssertEqual(movie.title, "The Dark Knight")
    }
    
    func test_getModels_success() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData(jsonFile: "Movies", url: url)
        
        let sut = MovieService(session: mocker.session)
        var results = (movies: [Movie](), totalPages: 0)
        
        XCTAssertNoThrow(results = try awaitPublisher( sut.getModels(endpoint: .NowPlaying) ))
        
        XCTAssertEqual(results.movies.count, 20)
        XCTAssertEqual(results.totalPages, 33)
    }
    
    func test_getModels_failsOnEmptyResult() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let emptyResult = [String:String]()
        let mocker = MockData(jsonObject: emptyResult, url: url)
        
        let sut = MovieService(session: mocker.session)
        var results: (movies: [Movie], totalPages: Int)?

        XCTAssertThrowsError(results = try awaitPublisher( sut.getModels(endpoint: .NowPlaying) ))
        XCTAssertNil(results)
    }
    
    func test_getModels_failsOn401Status() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData(jsonFile: "Movies", url: url, statusCode: 401)
        
        let sut = MovieService(session: mocker.session)
        var results: (movies: [Movie], totalPages: Int)?
        
        XCTAssertThrowsError(results = try awaitPublisher( sut.getModels(endpoint: .NowPlaying) ))
        XCTAssertNil(results)
    }
    
    func test_getModels_failsOn404Status() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData(jsonFile: "Movies", url: url, statusCode: 404)
        
        let sut = MovieService(session: mocker.session)
        var results: (movies: [Movie], totalPages: Int)?
        
        XCTAssertThrowsError(results = try awaitPublisher( sut.getModels(endpoint: .NowPlaying) ))
        XCTAssertNil(results)
    }

}
