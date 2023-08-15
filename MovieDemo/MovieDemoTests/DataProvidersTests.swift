//
//  DataProvidersTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 05/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
import Combine
@testable import MovieDemo

class DataProvidersTests: XCTestCase {
    
    //MARK: - PaginatedProvider Tests
    func test_PaginatedProvider_success() throws {
        let movies = anyMovies(count: 20)
        let movieLoaderMock = MovieLoaderMock(movies: movies, pageCount: 3)
        let dataProvider = PaginatedProvider(service: movieLoaderMock.getMovies)
        
        assertDataProviderPaging(dataProvider: dataProvider)
    }
    
    func test_PaginatedProvider_failure() throws {
        let movies = anyMovies(count: 20)
        let movieLoaderMock = MovieLoaderMock(movies: movies, pageCount: 3, error: TMDBClient.ServiceError.RequestError)
        let dataProvider = PaginatedProvider(service: movieLoaderMock.getMovies)
        
        //First try should fail
        assertDataProviderPagingFailure(dataProvider: dataProvider)
        
        //Setting the error to nil so retry should succeed
        movieLoaderMock.error = nil
        assertDataProviderPaging(dataProvider: dataProvider)
    }
}
 
//MARK: - Helpers
extension DataProvidersTests {
    func assertDataProviderPaging<T>(dataProvider: PaginatedProvider<T>) {
        var callCount = 0
        
        var exp = XCTestExpectation(description: "Page 1")
        let cancellable = dataProvider.$items
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                callCount += 1
                exp.fulfill()
            }
          
        //Page 1
        dataProvider.refresh()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(dataProvider.currentPage, 1)
        XCTAssertEqual(dataProvider.itemCount, 20)
        XCTAssertEqual(dataProvider.isLastPage, false)

        //Page 2
        exp = XCTestExpectation(description: "Page 2")
        
        dataProvider.loadMore()

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(dataProvider.currentPage, 2)
        XCTAssertEqual(dataProvider.itemCount, 40)
        XCTAssertEqual(dataProvider.isLastPage, false)

        //Page 3
        exp = XCTestExpectation(description: "Page 3")
        
        dataProvider.loadMore()

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(dataProvider.currentPage, 3)
        XCTAssertEqual(dataProvider.itemCount, 60)
        XCTAssertEqual(dataProvider.isLastPage, false)
        
        //Try to loadMore at last page
        dataProvider.loadMore()

        XCTAssertEqual(dataProvider.currentPage, 3)
        XCTAssertEqual(dataProvider.itemCount, 60)
        XCTAssertEqual(dataProvider.isLastPage, true)
        
        XCTAssertEqual(callCount, 4)
        
        cancellable.cancel()
    }
        
    func assertDataProviderPagingFailure<T>(dataProvider: PaginatedProvider<T>) {
        let exp = XCTestExpectation()
        let cancellable = dataProvider.$error
            .compactMap { $0 }
            .sink { error in
                XCTAssertNotNil(error)
                exp.fulfill()
            }
        
        dataProvider.refresh()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(dataProvider.currentPage, 0)
        XCTAssertEqual(dataProvider.itemCount, 0)
        XCTAssertEqual(dataProvider.isLastPage, true)
        
        cancellable.cancel()
    }

}
