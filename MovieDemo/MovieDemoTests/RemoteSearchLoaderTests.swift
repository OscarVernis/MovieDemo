//
//  RemoteSearchLoaderTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 05/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class RemoteSearchLoaderTests: XCTestCase {
    
    func test_RemoteSearchLoader_sucess() throws {
        let url = URL(string: "https://api.themoviedb.org/3/search/multi")!
        let mockClient = MockHTTPClient(jsonFile: "Search", url: url)
        let service = TMDBClient(httpClient: mockClient)
        let searchLoader = RemoteSearchLoader(service: service)
        
        var results = (items: [Any](), totalPages: 0)
        results = try awaitPublisher(
            searchLoader.search(query: "search")
        )
        
        XCTAssertEqual(results.items.count, 13)
        XCTAssertEqual(results.totalPages, 500)
        XCTAssert(results.items[0] is Person)
        XCTAssert(results.items[1] is Movie)
        XCTAssert(results.items[2] is Person)
        XCTAssert(results.items[3] is Movie)
    }

}
