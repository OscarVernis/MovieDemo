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
    
    func test_getModels_success() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData()
        
        mocker.register(jsonFile: "Movies", url: url)
        
        var results = (movies: [Movie](), totalPages: 0)
        let sut = MovieService(session: mocker.session)
        results = try! awaitPublisher( sut.getModels(model: Movie.self, endpoint: .NowPlaying) )
        
        XCTAssertEqual(results.movies.count, 20)
        XCTAssertEqual(results.totalPages, 33)
    }
    
    func test_getModels_failsOnEmptyResult() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = MockData()
        
        let emptyResult = [String:String]()
        mocker.register(jsonObject: emptyResult, url: url)

        var results = (movies: [Movie](), totalPages: 0)
        let sut = MovieService(session: mocker.session)
        do {
            results = try awaitPublisher( sut.getModels(model: Movie.self, endpoint: .NowPlaying) )
        } catch(let error) {
            XCTAssertNotNil(error)
        }
        
        XCTAssertEqual(results.movies.count, 0)
        XCTAssertEqual(results.totalPages, 0)
    }
    
}
