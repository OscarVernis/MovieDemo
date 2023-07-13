//
//  MovieDetailViewControllerTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 06/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
import Combine
@testable import MovieDemo

class MovieDetailViewControllerTests: XCTestCase {

    func test_deallocation() throws {
        assertDeallocation {
            let service = { Just(self.anyMovie()).setFailureType(to: Error.self).eraseToAnyPublisher() }
            let store = MovieDetailStore(movie: anyMovieVM(), movieService: service)
            return MovieDetailViewController(store: store, router: nil)
        }
    }
    
    func test_store_deallocation() async throws {
        let service = { Just(self.anyMovie()).setFailureType(to: Error.self).eraseToAnyPublisher() }
        let userService = MockUserStatesService()
        let store = MovieDetailStore(movie: anyMovieVM(), movieService: service, userStateService: userService)
        store.refresh()
        let _ = await store.markAsFavorite(true)
        let _ = await store.addToWatchlist(true)
        let _ = await store.rate(5)
        let _ = await store.deleteRate()
        trackForMemoryLeaks(store)
    }

}
