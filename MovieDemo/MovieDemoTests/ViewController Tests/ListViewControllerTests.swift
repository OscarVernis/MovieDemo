//
//  ListViewControllerTests.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 06/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import XCTest
@testable import MovieDemo

class ListViewControllerTests: XCTestCase {
    func test_deallocation() throws {
        assertDeallocation {
            let movies = anyMovies(count: 10).map { MovieViewModel(movie: $0) }
            
            let sut = ListViewController(models: movies, cellConfigurator: MovieInfoListCell.configure)
            sut.loadViewIfNeeded()
            
            return sut
        }
    }
    
}
