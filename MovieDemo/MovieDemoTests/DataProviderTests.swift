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

    func test_MovieDataProvider_success() throws {
        let movies = anyMovies(count: 20)
        let movieLoaderMock = MovieLoaderMock(movies: movies, pageCount: 3)
        
        let dataProvider = MoviesDataProvider(.NowPlaying, movieLoader: movieLoaderMock)
        
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
    
    func test_MovieDataProvider_failure() throws {
        let movies = anyMovies(count: 20)
        let movieLoaderMock = MovieLoaderMock(movies: movies, pageCount: 3, error: MovieService.ServiceError.ServiceError)
        let dataProvider = MoviesDataProvider(.NowPlaying, movieLoader: movieLoaderMock)
        
        //First try should fail
        dataProvider.didUpdate = { error in
            XCTAssertNotNil(error)
        }
        
        dataProvider.refresh()
        
        XCTAssertEqual(dataProvider.currentPage, 0)
        XCTAssertEqual(dataProvider.totalPages, 1)
        XCTAssertEqual(dataProvider.itemCount, 0)
        XCTAssertEqual(dataProvider.isLastPage, true)
        
        //Setting the error to nil so retry succedes
        movieLoaderMock.error = nil
        dataProvider.didUpdate = { error in
            XCTAssertNil(error)
        }
        
        //Retry
        dataProvider.refresh()
        
        XCTAssertEqual(dataProvider.currentPage, 1)
        XCTAssertEqual(dataProvider.totalPages, 3)
        XCTAssertEqual(dataProvider.itemCount, 20)
        XCTAssertEqual(dataProvider.isLastPage, false)
        
    }

}

//MARK: - MovieLoaderMock
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
