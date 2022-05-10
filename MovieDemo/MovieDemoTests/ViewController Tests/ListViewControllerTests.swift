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
    var sut: ListViewController!
    var coordinator: MainCoordinator!
    var dataProvider: MoviesDataProviderSpy!
    
    override func setUpWithError() throws {
        let movies = anyMovies(count: 20)
        let movieLoader = MovieLoaderMock(movies: movies, pageCount: 3)
        dataProvider = MoviesDataProviderSpy(movieLoader: movieLoader)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        coordinator = appDelegate?.appCoordinator
        
        coordinator?.showMovieList(title: "", dataProvider: dataProvider, animated: false)
        let topVC = coordinator?.rootNavigationViewController?.topViewController
        let sut = topVC as? ListViewController

        self.sut = try XCTUnwrap(sut, "Expected ListViewController, " + "but was \(String(describing: topVC))")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        coordinator = nil
    }
    
    func test_deallocation() throws {
        assertDeallocation {
            let movies = anyMovies(count: 10).map(MovieViewModel.init)
            let dataProvider = StaticArrayDataProvider(models: movies)
            let section = DataProviderSection(dataProvider: dataProvider, cellConfigurator: MovieInfoCellConfigurator())
            
            return ListViewController(section: section)
        }
    }
    
    func test_pageLoading() {
        //Load First Page (Refresh)
        sut.loadViewIfNeeded()
        XCTAssertEqual(dataProvider.refreshCount, 1)
        XCTAssertEqual(dataProvider.currentPage, 1)

        //Scroll to last item to load next page (2)
        var lastIndexPath = IndexPath(row: 19, section: 0)
        sut.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
        
        executeRunLoop()
        XCTAssertEqual(dataProvider.loadMoreCount, 1)
        XCTAssertEqual(dataProvider.currentPage, 2)

        //Scroll to last item to load next page (3)
        executeRunLoop()
        lastIndexPath = IndexPath(row: 39, section: 0)
        sut.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
        
        executeRunLoop()
        XCTAssertEqual(dataProvider.loadMoreCount, 2)
        XCTAssertEqual(dataProvider.currentPage, 3)
        
        //Scroll to last item should't load more since its already at last page.
        executeRunLoop()
        lastIndexPath = IndexPath(row: 59, section: 0)
        sut.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
        
        executeRunLoop()
        XCTAssertEqual(dataProvider.loadMoreCount, 2)
        XCTAssertEqual(dataProvider.currentPage, 3)
        
        //Scroll to top and refresh
        sut.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: false)
        sut.collectionView.refreshControl?.sendActions(for: .valueChanged)
                
        executeRunLoop()
        XCTAssertEqual(dataProvider.refreshCount, 2)
        XCTAssertEqual(dataProvider.currentPage, 1)
    }
    
    func test_showsDetail() throws {
        sut.loadViewIfNeeded()

        sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                
        executeRunLoop()
        let topVC = coordinator.rootNavigationViewController?.topViewController
        XCTAssert(topVC is MovieDetailViewController)
    }
    
}

//MARK: - Spy
class MoviesDataProviderSpy: MoviesDataProvider {
    var loadMoreCount = 0
    var refreshCount = 0
    
    override func refresh() {
        refreshCount += 1
        super.refresh()
    }
    
    override func loadMore() {
        loadMoreCount += 1
        super.loadMore()
    }
}
