//
//  HomeViewControllerTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 06/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class HomeViewControllerTests: XCTestCase {

    func test_deallocation() throws {
        assertDeallocation {
            HomeViewController(router: nil,
                               nowPlayingProvider: MoviesProvider(service: MovieLoaderMock().getViewModels),
                               upcomingProvider: MoviesProvider(service: MovieLoaderMock().getViewModels),
                               popularProvider: MoviesProvider(service: MovieLoaderMock().getViewModels),
                               topRatedProvider: MoviesProvider(service: MovieLoaderMock().getViewModels))
        }
    }

}
