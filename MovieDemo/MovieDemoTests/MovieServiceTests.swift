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
    
    func test_getModel_success() throws {
        let movieId = 155
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)")!
        let mocker = ServiceMocker(jsonFile: "Movie", url: url)
        
        let sut = MovieService(session: mocker.session)
        var movie = Movie()
        
        movie = try awaitPublisher(
            sut.getModel(endpoint: .movieDetails(movieId: movieId))
        )
        
        XCTAssertEqual(movie.id, movieId)
        XCTAssertEqual(movie.title, "The Dark Knight")
    }
    
    func test_getModels_success() throws {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = ServiceMocker(jsonFile: "Movies", url: url)
        
        let sut = MovieService(session: mocker.session)
        var results: ServiceModelsResult<Movie>?
        
        results = try awaitPublisher(
            sut.getModels(endpoint: .movies(.NowPlaying))
        )
        
        XCTAssertEqual(results?.items.count, 20)
        XCTAssertEqual(results?.totalPages, 33)
    }
    
    func test_getModels_failsOnEmptyResult() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let emptyResult = [String:String]()
        let mocker = ServiceMocker(jsonObject: emptyResult, url: url)
        
        let sut = MovieService(session: mocker.session)
        var results: ServiceModelsResult<Movie>?

        XCTAssertThrowsError(results = try awaitPublisher( sut.getModels(endpoint: .movies(.NowPlaying)) ))
        XCTAssertNil(results)
    }
    
    func test_getModels_failsOn401Status() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = ServiceMocker(jsonFile: "Movies", url: url, statusCode: 401)
        
        let sut = MovieService(session: mocker.session)
        var results: ServiceModelsResult<Movie>?
        
        XCTAssertThrowsError(results = try awaitPublisher( sut.getModels(endpoint: .movies(.NowPlaying)) ))
        XCTAssertNil(results)
    }
    
    func test_getModels_failsOn404Status() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
        let mocker = ServiceMocker(jsonFile: "Movies", url: url, statusCode: 404)
        
        let sut = MovieService(session: mocker.session)
        var results: ServiceModelsResult<Movie>?
        
        XCTAssertThrowsError(results = try awaitPublisher( sut.getModels(endpoint: .movies(.NowPlaying)) ))
        XCTAssertNil(results)
    }
    
    func test_successAction_succeeds() throws {
        let url = URL(string: "https://api.themoviedb.org/3/account/id/favorite")!
        let data = ServiceSuccessResult(success: true, sessionId: "sessionId", requestToken: "requestToken")
        let mocker = ServiceMocker(jsonObject: data, url: url)
        let sut = MovieService(session: mocker.session)
        
        var result: ServiceSuccessResult?
        
        result = try awaitPublisher(
            sut.successAction(endpoint: .markAsFavorite)
        )
        
        XCTAssertEqual(result?.success, true)
        XCTAssertEqual(result?.sessionId, "sessionId")
        XCTAssertEqual(result?.requestToken, "requestToken")
    }
    
    func test_successAction_thowsError_onFailure() {
        let url = URL(string: "https://api.themoviedb.org/3/account/id/favorite")!
        let data = ServiceSuccessResult(success: false)
        let mocker = ServiceMocker(jsonObject: data, url: url)
        let sut = MovieService(session: mocker.session)
                
        XCTAssertThrowsError(try awaitPublisher( sut.successAction(endpoint: .markAsFavorite)) ) { error in
            XCTAssertEqual(error as? MovieService.ServiceError, MovieService.ServiceError.NoSuccess)
        }
    }
    
    func test_successAction_thowsError_onWrongData() {
        let url = URL(string: "https://api.themoviedb.org/3/account/id/favorite")!
        let mocker = ServiceMocker(jsonFile: "Movies", url: url)
        
        let sut = MovieService(session: mocker.session)
        
        XCTAssertThrowsError(try awaitPublisher( sut.successAction(endpoint: .markAsFavorite)) )
    }
    
    func test_successAction_thowsError_On404Status() {
        let url = URL(string: "https://api.themoviedb.org/3/account/id/favorite")!
        let data = ServiceSuccessResult(success: true)
        let mocker = ServiceMocker(jsonObject: data, url: url, statusCode: 404)
        let sut = MovieService(session: mocker.session)
                
        XCTAssertThrowsError(try awaitPublisher( sut.successAction(endpoint: .markAsFavorite)) )
    }
    
    func test_successAction_async_succeeds() async throws {
        let url = URL(string: "https://api.themoviedb.org/3/account/id/watchlist")!
        let data = ServiceSuccessResult(success: true, sessionId: "sessionId", requestToken: "requestToken")
        let mocker = ServiceMocker(jsonObject: data, url: url)
        let sut = MovieService(session: mocker.session)
        
        var result: ServiceSuccessResult?
        do {
            result = try await  sut.successAction(endpoint: .addToWatchlist).async()
        } catch {
            XCTAssertNil(error)
        }
        
        XCTAssertEqual(result?.success, true)
        XCTAssertEqual(result?.sessionId, "sessionId")
        XCTAssertEqual(result?.requestToken, "requestToken")
    }
    
    func test_successAction_async_fails() async throws {
        let url = URL(string: "https://api.themoviedb.org/3/account/id/watchlist")!
        let data = ServiceSuccessResult(success: false, sessionId: "sessionId", requestToken: "requestToken")
        let mocker = ServiceMocker(jsonObject: data, url: url)
        let sut = MovieService(session: mocker.session)
        
        var resultError: Error? = nil
        do {
            let _ = try await  sut.successAction(endpoint: .addToWatchlist).async()
        } catch {
            resultError = error
        }
        
        XCTAssertNotNil(resultError)
    }
    
}
