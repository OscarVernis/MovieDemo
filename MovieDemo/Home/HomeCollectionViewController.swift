//
//  HomeViewControllerCollectionViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Alamofire

class HomeCollectionViewController: UIViewController {    
    weak var mainCoordinator: MainCoordinator!
    
    var dataSource: HomeCollectionViewDataSource!
    var searchDataProvider = MovieListDataProvider()
    
    var collectionView: UICollectionView!
    var sections: [HomeSection]!
    
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "Movies"
        
        manager?.startListening { status in
            if status == .notReachable || status == .unknown {
                AlertManager.showNetworkConnectionAlert(sender: self)
            }
        }
                
        setupSearch()
        setupCollectionView()
        setupDataSource()
    }
    
    fileprivate func setupDataSource() {
        let didUpdate: (Int) -> Void = { [weak self] section in
            self?.collectionView.refreshControl?.endRefreshing()
            self?.collectionView.reloadData()
        }
        
        sections = [
            HomeSection(.NowPlaying, index: 0, didUpdate: didUpdate),
            HomeSection(.Upcoming, index: 1, didUpdate: didUpdate),
            HomeSection(.Popular, index: 2, didUpdate: didUpdate),
            HomeSection(.TopRated, index: 3, didUpdate: didUpdate)
        ]
        
        dataSource = HomeCollectionViewDataSource(sections: sections)
        dataSource.sectionHeaderButtonHandler = { [weak self] section in
            self?.showMovieList(section: section)
        }
        
        collectionView.dataSource = dataSource
    }
    
    fileprivate func setupSearch() {
        let movieListController = ListViewController<MovieListDataProvider, MovieInfoCellConfigurator>()
        movieListController.dataProvider = searchDataProvider
        movieListController.dataSource = ListViewDataSource(reuseIdentifier: MovieInfoListCell.reuseIdentifier, configurator: MovieInfoCellConfigurator())
        movieListController.mainCoordinator = mainCoordinator

        movieListController.didSelectedItem = { [weak self] index, movie in
            self?.mainCoordinator.showMovieDetail(movie: movie)
        }

        let search = UISearchController(searchResultsController: movieListController)
        search.searchResultsUpdater = self
        search.delegate = self
        navigationItem.searchController = search
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(named: "AppBackgroundColor")
        view.addSubview(collectionView)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        MoviePosterInfoCell.register(withCollectionView: collectionView)
        MovieBannerCell.register(withCollectionView: collectionView)
        MovieRatingListCell.register(withCollectionView: collectionView)
        MovieInfoListCell.register(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
    }
    
//MARK: - Actions
    @objc func refresh() {
        sections.forEach { $0.dataProvider.refresh() }
    }
    
    func showMovieList(section: HomeSection) {
        let dataProvider = MovieListDataProvider(section.dataProvider.currentService)
        mainCoordinator.showMovieList(title: section.title, dataProvider: dataProvider)
    }

}

//MARK: - CollectionView CompositionalLayout
extension HomeCollectionViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            var section: NSCollectionLayoutSection?
            let sectionBuilder = MoviesCompositionalLayoutBuilder()
            
            let sectionHeader = sectionBuilder.createTitleSectionHeader()
            
            switch sectionIndex {
            case 0:
                section = sectionBuilder.createBannerSection()
            case 1:
                section = sectionBuilder.createHorizontalPosterSection()
            case 2:
                section = sectionBuilder.createInfoListSection()
            case 3:
                section = sectionBuilder.createDecoratedListSection()
                sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            default:
                section = nil
            }
            
            section?.boundarySupplementaryItems = [sectionHeader]

            return section
        }
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
        
        return layout
    }

}

// MARK: - CollectionView Delegate
extension HomeCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        let movie = section.movies[indexPath.row]
                
        mainCoordinator.showMovieDetail(movie: movie)
    }
    
}

// MARK: - Searching
extension HomeCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty {
            searchDataProvider.currentService = .Search(query: searchQuery)
        }
    }
}

