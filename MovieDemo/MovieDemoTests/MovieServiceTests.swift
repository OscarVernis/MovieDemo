//
//  MovieServiceTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 21/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
import Combine
import Alamofire
import Mocker
@testable import MovieDemo

class MovieServiceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cancellables = []
    }

    func test_getModels_success() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)

        let apiEndpoint = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        
        let mockedData = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Movies", withExtension: "json")!)
        let mock = Mock(url: apiEndpoint, ignoreQuery: true, dataType: .json, statusCode: 200, data: [
            .get : mockedData
        ])
        mock.register()
        
        var movieCount = 0
        var pages = 0
        var error: Error?
        let expectation = self.expectation(description: "Get Movies")
        
        let sut = MovieService(session: sessionManager)

        sut.getModels(model: Movie.self, endpoint: .NowPlaying)
            .sink { completion  in
                switch completion {
                case .finished:
                    break
                case .failure(let serviceError):
                    error = serviceError
                }

                expectation.fulfill()
            } receiveValue: { movies, totalPages in
                movieCount = movies.count
                pages = totalPages
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
        
        XCTAssertEqual(movieCount, 20)
        XCTAssertEqual(pages, 33)
        XCTAssertNil(error)
    }

}
