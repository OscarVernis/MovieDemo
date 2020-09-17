//
//  HomeViewControllerCollectionViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    weak var mainCoordinator: MainCoordinator!
    
    var dataSource: HomeCollectionViewDataSource!
    var searchDataProvider = MovieListDataProvider(.Search)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupSearch()
        setupCollectionView()
        setupDataSource()
    }
    
    fileprivate func setupDataSource() {
        let sections = [
            HomeSection(.NowPlaying, index: 0, didUpdate: updateSection),
            HomeSection(.Upcoming, index: 1, didUpdate: updateSection),
            HomeSection(.Popular, index: 2, didUpdate: updateSection),
            HomeSection(.TopRated, index: 3, didUpdate: updateSection)
        ]
        
        dataSource = HomeCollectionViewDataSource(sections: sections)
        dataSource.sectionHeaderButtonHandler = showMovieList(section:)
        
        collectionView.dataSource = dataSource
    }
    
    fileprivate func setupSearch() {
        let movieListController = ListViewController<MovieListDataProvider, MovieInfoCellConfigurator>()
        movieListController.dataProvider = searchDataProvider
        movieListController.dataSource = ListViewDataSource(reuseIdentifier: MovieInfoCell.reuseIdentifier, configurator: MovieInfoCellConfigurator())
        movieListController.mainCoordinator = self.mainCoordinator
        
        movieListController.didSelectedItem = { index, movie in
            self.mainCoordinator.showMovieDetail(movie: movie)
        }
        
        let search = UISearchController(searchResultsController: movieListController)
        search.searchResultsUpdater = self
        search.delegate = self
        self.navigationItem.searchController = search
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(MovieBannerCell.namedNib(), forCellWithReuseIdentifier: MovieBannerCell.reuseIdentifier)
        collectionView.register(MoviePosterCell.namedNib(), forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        collectionView.register(MovieListCell.namedNib(), forCellWithReuseIdentifier: MovieListCell.reuseIdentifier)
        collectionView.register(MovieInfoCell.namedNib(), forCellWithReuseIdentifier: MovieInfoCell.reuseIdentifier)
        collectionView.register(SectionTitleView.namedNib(), forSupplementaryViewOfKind: HomeCollectionViewController.sectionHeaderElementKind, withReuseIdentifier: SectionTitleView.reuseIdentifier)
        
        collectionView.collectionViewLayout = createLayout()
    }
    
//MARK: - Actions
    func showMovieList(section: HomeSection) {
        let dataProvider = MovieListDataProvider(section.dataProvider.currentService)
        mainCoordinator.showMovieList(title: section.title, dataProvider: dataProvider)
    }
    
    func updateSection(_ section: Int) {
        collectionView.reloadSections(IndexSet(integer: section))
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
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: HomeCollectionViewController.sectionBackgroundDecorationElementKind)
        
        return layout
    }

}

// MARK: - CollectionView Delegate
extension HomeCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        let movie = section.movies[indexPath.row]
                
        mainCoordinator.showMovieDetail(movie: movie)
    }
    
}

// MARK: - Searching
extension HomeCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchDataProvider.searchQuery = searchController.searchBar.text ?? ""
    }
}

