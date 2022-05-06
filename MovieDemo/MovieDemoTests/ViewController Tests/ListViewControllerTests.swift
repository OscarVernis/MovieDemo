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
            let movies = anyMovies(count: 10).map(MovieViewModel.init)
            let dataProvider = StaticArrayDataProvider(models: movies)
            let section = DataProviderSection(dataProvider: dataProvider, cellConfigurator: MovieInfoCellConfigurator())
            
            return ListViewController(section: section)
        }
    }
}
