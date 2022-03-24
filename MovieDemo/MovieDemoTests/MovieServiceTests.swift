//
//  MovieServiceTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
import Combine
@testable import MovieDemo

class MovieServiceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cancellables = []
    }
    
    func test_getModel_success() {
        let movieId = 155
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)")!
        let mocker = MockData()
        
        mocker.register(jsonFile: "Movie", url: url)
        
        var movie: Movie?
        let sut = MovieService(session: mocker.session)
        movie = try! awaitPublisher( sut.getModel(endpoint: .MovieDetails(movieId: movieId)) )
        
        XCTAssertEqual(movie?.id, movieId)
        XCTAssertEqual(movie?.title, "The Dark Knight")
    }
    
    func test_getModels_success() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData()
        
        mocker.register(jsonFile: "Movies", url: url)
        let results: (movies: [Movie], totalPages: Int)? = runGetModels(mocker: mocker, endpoint: .NowPlaying)
        
        XCTAssertEqual(results?.movies.count, 20)
        XCTAssertEqual(results?.totalPages, 33)
    }
    
    func test_getModels_failsOnEmptyResult() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData()
        
        let emptyResult = [String:String]()
        mocker.register(jsonObject: emptyResult, url: url)

        let results: ([Movie], Int)? = runGetModels(mocker: mocker, endpoint: .NowPlaying)
        
        XCTAssertNil(results)
    }
    
    func test_getModels_failsOn401Status() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData()
        
        mocker.register(jsonFile: "Movies", url: url, statusCode: 401)
        let results: ([Movie], Int)? = runGetModels(mocker: mocker, endpoint: .NowPlaying)
        
        XCTAssertNil(results)
    }
    
    func test_getModels_failsOn404Status() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData()
        
        mocker.register(jsonFile: "Movies", url: url, statusCode: 404)
        let results: ([Movie], Int)? = runGetModels(mocker: mocker, endpoint: .NowPlaying)
        
        XCTAssertNil(results)
    }

    //MARK: - Helpers
    func runGetModels<T>(mocker: MockData, endpoint: MovieService.Endpoint) -> T? {
        var results: T? = nil
        let sut = MovieService(session: mocker.session)
        do {
            results = try awaitPublisher( sut.getModels(model: Movie.self, endpoint: endpoint) ) as? T
        } catch(let error) {
            XCTAssertNotNil(error)
        }
        
        return results
    }
}
