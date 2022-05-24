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
    
    //MARK: - StaticArrayDataProvider Tests
    func test_StaticArrayDataProvider_success() throws {
        let movies = anyMovies(count: 20)
        var dataProvider = StaticArrayDataProvider(models: movies)
        
        dataProvider.didUpdate = { error in
            XCTAssertNil(error)
        }
                
        XCTAssertEqual(dataProvider.itemCount, 20)
        XCTAssertEqual(dataProvider.isLastPage, true)
    }

    //MARK: - MovieDataProvider Tests
    func test_MovieDataProvider_success() throws {
        let movies = anyMovies(count: 20)
        let movieLoaderMock = MovieLoaderMock(movies: movies, pageCount: 3)
        let dataProvider = MoviesDataProvider(.NowPlaying, movieLoader: movieLoaderMock)
        
        assertDataProviderPaging(dataProvider: dataProvider)
    }
    
    func test_MovieDataProvider_failure() throws {
        let movies = anyMovies(count: 20)
        let movieLoaderMock = MovieLoaderMock(movies: movies, pageCount: 3, error: MovieService.ServiceError.RequestError)
        let dataProvider = MoviesDataProvider(.NowPlaying, movieLoader: movieLoaderMock, cache: nil)
        
        //First try should fail
        assertDataProviderPagingFailure(dataProvider: dataProvider)
        
        //Setting the error to nil so retry should succeed
        movieLoaderMock.error = nil
        assertDataProviderPaging(dataProvider: dataProvider)
    }
    
    //MARK: - SearchDataProvider Tests
    func test_SearchDataProvider_query() throws {
        let results: [Any] = anyMovies(count: 5) + anyPersons(count: 5)
        let searchLoader = SearchLoaderMock(results: results, pageCount: 3)
        let dataProvider = SearchDataProvider(searchLoader: searchLoader)
        
        var callCount = 0
        dataProvider.didUpdate = { error in
            XCTAssertNil(error)
            callCount += 1
        }
        
        //$query Publisher has a debounce (0.3) so search should only be called once.
        dataProvider.query = "S"
        dataProvider.query = "Sea"
        dataProvider.query = "Search"
        wait(for: 0.35)
        
        XCTAssertEqual(dataProvider.query, "Search")
        XCTAssert(dataProvider.item(atIndex: 0) is MovieViewModel)
        XCTAssert(dataProvider.item(atIndex: 5) is PersonViewModel)
        XCTAssertEqual(callCount, 1)

    }
    
    func test_SearchDataProvider_success() throws {
        let results: [Any] = anyMovies(count: 10) + anyPersons(count: 10)
        let searchLoader = SearchLoaderMock(results: results, pageCount: 3)
        let dataProvider = SearchDataProvider(searchLoader: searchLoader)
        
        dataProvider.query = "Search"
        wait(for: 0.35)
        
        assertDataProviderPaging(dataProvider: dataProvider)
    }
    
    func test_SearchDataProvider_failure() throws {
        let results: [Any] = anyMovies(count: 10) + anyPersons(count: 10)
        let searchLoader = SearchLoaderMock(results: results, pageCount: 3, error: MovieService.ServiceError.RequestError)
        let dataProvider = SearchDataProvider(searchLoader: searchLoader)
        
        dataProvider.query = "Search"
        wait(for: 0.35)
        
        //First try should fail
        assertDataProviderPagingFailure(dataProvider: dataProvider)
        
        //Setting the error to nil so retry succeds
        searchLoader.error = nil
        assertDataProviderPaging(dataProvider: dataProvider)
    }
    
}
 
//MARK: - Helpers
extension DataProvidersTests {
    func assertDataProviderPaging<T>(dataProvider: PaginatedDataProvider<T>) {
        var callCount = 0
        dataProvider.didUpdate = { error in
            XCTAssertNil(error)
            callCount += 1
        }
        
        //Page 1
        dataProvider.refresh()
        
        XCTAssertEqual(dataProvider.currentPage, 1)
        XCTAssertEqual(dataProvider.totalPages, 3)
        XCTAssertEqual(dataProvider.itemCount, 20)
        XCTAssertEqual(dataProvider.isLastPage, false)

        //Page 2
        dataProvider.loadMore()

        XCTAssertEqual(dataProvider.currentPage, 2)
        XCTAssertEqual(dataProvider.totalPages, 3)
        XCTAssertEqual(dataProvider.itemCount, 40)
        XCTAssertEqual(dataProvider.isLastPage, false)

        //Page 3
        dataProvider.loadMore()

        XCTAssertEqual(dataProvider.currentPage, 3)
        XCTAssertEqual(dataProvider.totalPages, 3)
        XCTAssertEqual(dataProvider.itemCount, 60)
        XCTAssertEqual(dataProvider.isLastPage, true)
        
        //Try to loadMore at last page
        dataProvider.loadMore()

        XCTAssertEqual(dataProvider.currentPage, 3)
        XCTAssertEqual(dataProvider.totalPages, 3)
        XCTAssertEqual(dataProvider.itemCount, 60)
        XCTAssertEqual(dataProvider.isLastPage, true)
        
        XCTAssertEqual(callCount, 3)
    }
        
    func assertDataProviderPagingFailure<T>(dataProvider: PaginatedDataProvider<T>) {
        dataProvider.didUpdate = { error in
            XCTAssertNotNil(error)
        }
        
        dataProvider.refresh()
        
        XCTAssertEqual(dataProvider.currentPage, 0)
        XCTAssertEqual(dataProvider.totalPages, 1)
        XCTAssertEqual(dataProvider.itemCount, 0)
        XCTAssertEqual(dataProvider.isLastPage, true)
    }

}

//MARK: - Mock
class SearchLoaderMock: SearchLoader {
    let results: [Any]
    var pageCount: Int
    var error: Error?
    
    init(results: [Any], pageCount: Int = 1, error: Error? = nil) {
        self.results = results
        self.pageCount = pageCount
        self.error = error
    }
    
    func search(query: String, page: Int) -> AnyPublisher<([Any], Int), Error> {
        if let error = error {
            return Fail(outputType: ([Any], Int).self, failure: error)
                .eraseToAnyPublisher()
        }
        
        return Just( (results, pageCount) )
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
