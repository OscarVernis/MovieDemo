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
            HomeSection(.NowPlaying, index: 0, didUpdate: updateSection(_:)),
            HomeSection(.Upcoming, index: 1, didUpdate: updateSection(_:)),
            HomeSection(.Popular, index: 2, didUpdate: updateSection(_:)),
            HomeSection(.TopRated, index: 3, didUpdate: updateSection(_:))
        ]
        
        dataSource = HomeCollectionViewDataSource(sections: sections)
        dataSource.sectionHeaderButtonHandler = showMovieList(section:)
        
        collectionView.dataSource = dataSource
    }
    
    fileprivate func setupSearch() {
        let movieListController = MovieListViewController.instantiateFromStoryboard()
        movieListController.dataProvider = searchDataProvider
        movieListController.mainCoordinator = self.mainCoordinator
        
        let search = UISearchController(searchResultsController: movieListController)
        search.searchResultsUpdater = self
        search.delegate = self
        self.navigationItem.searchController = search
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(UINib(nibName: "MovieBannerCell", bundle: .main), forCellWithReuseIdentifier: MovieBannerCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "MoviePosterCell", bundle: .main), forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "MovieListCell", bundle: .main), forCellWithReuseIdentifier: MovieListCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "MovieInfoCell", bundle: .main), forCellWithReuseIdentifier: MovieInfoCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "SectionTitleView", bundle: .main), forSupplementaryViewOfKind: HomeCollectionViewController.sectionHeaderElementKind, withReuseIdentifier: SectionTitleView.reuseIdentifier)
        
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
            
            switch sectionIndex {
            case 0:
                section = sectionBuilder.createBannerSection()
            case 1:
                section = sectionBuilder.createHorizontalPosterSection()
            case 2:
                section = sectionBuilder.createInfoListSection()
            case 3:
                section = sectionBuilder.createDecoratedListSection()
            default:
                section = nil
            }

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

