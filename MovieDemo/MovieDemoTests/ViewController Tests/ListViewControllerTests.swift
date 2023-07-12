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
    var sut: ListViewController<MoviesDataProviderSpy, MovieInfoListCell>!
    var coordinator: MainCoordinator!
    var dataProvider: MoviesDataProviderSpy!
    let window = UIWindow()

    override func setUpWithError() throws {
        let movies = anyMovies(count: 20)
        let movieLoader = MovieLoaderMock(movies: movies, pageCount: 3)
        dataProvider = MoviesDataProviderSpy(service: movieLoader.getMovies)
        
        let window = UIWindow()
        coordinator = MainCoordinator(window: window)
        coordinator.start()
        
        coordinator?.showMovieList(title: "", dataProvider: dataProvider, animated: false)
        let topVC = coordinator?.rootNavigationViewController?.topViewController
        let sut = topVC as? ListViewController<MoviesDataProviderSpy, MovieInfoListCell>

        self.sut = try XCTUnwrap(sut, "Expected ListViewController, " + "but was \(String(describing: topVC))")
    }
    
    override func tearDownWithError() throws {
        coordinator.rootNavigationViewController?.viewControllers = []
        
        sut = nil
        coordinator = nil
        dataProvider = nil
    }
    
    func test_deallocation() throws {
        assertDeallocation {
            let movies = anyMovies(count: 10).map { MovieViewModel(movie: $0) }
            let dataProvider = BasicProvider(models: movies)
            let dataSource = ProviderDataSource(dataProvider: dataProvider,
                                                reuseIdentifier: MovieInfoListCell.reuseIdentifier,
                                                cellConfigurator: MovieInfoListCell.configure)
            
            let sut = ListViewController(dataSource: dataSource, router: nil)
            sut.loadViewIfNeeded()
            
            return sut
        }
    }
    
    func test_Delegates() {
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.collectionView.delegate)
        XCTAssertNotNil(sut.collectionView.dataSource)
    }
    
    func test_pageLoading() {
        //Load First Page (Refresh)
        sut.loadViewIfNeeded()
        var cellCount = sut.collectionView.dataSource?.collectionView(sut.collectionView, numberOfItemsInSection: 0)

        XCTAssertEqual(dataProvider.refreshCount, 1)
        XCTAssertEqual(dataProvider.currentPage, 1)
        XCTAssertEqual(cellCount, 20)

        //Scroll to last item to load next page (2)
        var lastIndexPath = IndexPath(row: 19, section: 0)
        sut.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
        
        executeRunLoop()
        cellCount = sut.collectionView.dataSource?.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(dataProvider.loadMoreCount, 1)
        XCTAssertEqual(dataProvider.currentPage, 2)
        XCTAssertEqual(cellCount, 40)

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
        cellCount = sut.collectionView.dataSource?.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(dataProvider.loadMoreCount, 2)
        XCTAssertEqual(dataProvider.currentPage, 3)
        XCTAssertEqual(cellCount, 60)
        
        //Scroll to top and refresh
        sut.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: false)
        sut.collectionView.refreshControl?.sendActions(for: .valueChanged)
                
        executeRunLoop()
        cellCount = sut.collectionView.dataSource?.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(dataProvider.refreshCount, 2)
        XCTAssertEqual(dataProvider.currentPage, 1)
        XCTAssertEqual(cellCount, 20)

    }
    
    func test_showsDetail() throws {
        sut.loadViewIfNeeded()

        sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
                
        executeRunLoop()
        let topVC = coordinator.rootNavigationViewController?.topViewController
        XCTAssert(topVC is MovieDetailViewController, "Expected MovieDetailViewController, " + "but was \(String(describing: topVC))")
    }
    
}

//MARK: - Spy
class MoviesDataProviderSpy: MoviesProvider {
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
