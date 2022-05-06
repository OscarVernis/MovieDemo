//
//  DataProviderTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 05/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
import Combine
@testable import MovieDemo

class DataProviderTests: XCTestCase {
    
    //MARK: - StaticArrayDataProvider Tests
    func test_StaticArrayDataProvider_success() throws {
        let movies = anyMovies(count: 20)
        var dataProvider = StaticArrayDataProvider(models: movies)
        
        dataProvider.didUpdate = { error in
            XCTAssertNil(error)
        }
                
        XCTAssertEqual(dataProvider.currentPage, 1)
        XCTAssertEqual(dataProvider.totalPages, 1)
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
        let movieLoaderMock = MovieLoaderMock(movies: movies, pageCount: 3, error: MovieService.ServiceError.ServiceError)
        let dataProvider = MoviesDataProvider(.NowPlaying, movieLoader: movieLoaderMock)
        
        //First try should fail
        assertDataProviderPagingFailure(dataProvider: dataProvider)
        
        //Setting the error to nil so retry succeds
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
        
        //$query Publisher has a debounce so search should only be called once.
        let exp = XCTestExpectation()
        dataProvider.query = "S"
        dataProvider.query = "Sea"
        dataProvider.query = "Search"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exp.fulfill()
        }
                
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(dataProvider.query, "Search")
        XCTAssert(dataProvider.item(atIndex: 0) is MovieViewModel)
        XCTAssert(dataProvider.item(atIndex: 5) is PersonViewModel)
        XCTAssertEqual(callCount, 1)

    }
    
    func test_SearchDataProvider_success() throws {
        let results: [Any] = anyMovies(count: 10) + anyPersons(count: 10)
        let searchLoader = SearchLoaderMock(results: results, pageCount: 3)
        let dataProvider = SearchDataProvider(searchLoader: searchLoader)
        
        let exp = XCTestExpectation()
        dataProvider.query = "Search"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exp.fulfill()
        }
                
        wait(for: [exp], timeout: 1)
        assertDataProviderPaging(dataProvider: dataProvider)
    }
    
    func test_SearchDataProvider_failure() throws {
        let results: [Any] = anyMovies(count: 10) + anyPersons(count: 10)
        let searchLoader = SearchLoaderMock(results: results, pageCount: 3, error: MovieService.ServiceError.ServiceError)
        let dataProvider = SearchDataProvider(searchLoader: searchLoader)
        
        let exp = XCTestExpectation()
        dataProvider.query = "Search"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exp.fulfill()
        }
                
        wait(for: [exp], timeout: 1)
        //First try should fail
        assertDataProviderPagingFailure(dataProvider: dataProvider)
        
        //Setting the error to nil so retry succeds
        searchLoader.error = nil
        assertDataProviderPaging(dataProvider: dataProvider)
    }
    
}
 
//MARK: - Helpers
extension DataProviderTests {
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
        
        //Assert Completion was called everytime (Completion is not called if already at last page)
        XCTAssertEqual(callCount, 3)
    }
    
    func assertDataProviderPagingFailure<T>(dataProvider: PaginatedDataProvider<T>) {
        //First try should fail
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

//MARK: - Mocks
class MovieLoaderMock: MovieLoader {
    var pageCount: Int
    var movies: [Movie]
    var error: Error?
    
    init(movies: [Movie] = [], pageCount: Int = 1, error: Error? = nil) {
        self.pageCount = pageCount
        self.movies = movies
        self.error = error
    }
    
    func getMovies(movieList: MovieList, page: Int) -> AnyPublisher<([Movie], Int), Error> {
        if let error = error {
            return Fail(outputType: ([Movie], Int).self, failure: error)
                .eraseToAnyPublisher()
        }
        
        return Just( (movies, pageCount) )
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}

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
