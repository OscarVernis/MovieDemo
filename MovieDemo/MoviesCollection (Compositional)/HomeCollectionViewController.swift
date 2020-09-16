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
            HomeSection(.Popular, index: 1, didUpdate: updateSection(_:)),
            HomeSection(.TopRated, index: 2, didUpdate: updateSection(_:)),
            HomeSection(.Upcoming, index: 3, didUpdate: updateSection(_:)),
        ]
        
        dataSource = HomeCollectionViewDataSource(sections: sections)
        dataSource.sectionHeaderButtonHandler = showMovieList(section:)
        
        collectionView.dataSource = dataSource
    }
    
    fileprivate func setupSearch() {
        let movieListController = MoviesViewController.instantiateFromStoryboard()
        movieListController.dataProvider = searchDataProvider
        
        let search = UISearchController(searchResultsController: movieListController)
        search.searchResultsUpdater = self
        search.delegate = self
        self.navigationItem.searchController = search
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(UINib(nibName: "MovieImageCell", bundle: .main), forCellWithReuseIdentifier: MovieImageCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "MovieListCell", bundle: .main), forCellWithReuseIdentifier: MovieListCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "MovieInfoCell", bundle: .main), forCellWithReuseIdentifier: MovieInfoCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "SectionTitleView", bundle: .main), forSupplementaryViewOfKind: HomeCollectionViewController.sectionHeaderElementKind, withReuseIdentifier: SectionTitleView.reuseIdentifier)
        
        collectionView.collectionViewLayout = createLayout()
    }
    
//MARK: - Actions
    func showMovieList(section: HomeSection) {
        let movieListController = MoviesViewController.instantiateFromStoryboard()
        
        movieListController.title = section.title
        movieListController.dataProvider = MovieListDataProvider(section.dataProvider.currentService)
        show(movieListController, sender: nil)
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
                section = sectionBuilder.createDecoratedListSection()
            case 3:
                section = sectionBuilder.createInfoListSection()
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
        let detail = MovieDetailViewController.instantiateFromStoryboard()
        let section = dataSource.sections[indexPath.section]
        let movie = section.movies[indexPath.row]
        detail.movie = movie
        
        navigationController?.pushViewController(detail, animated: true)
    }
    
}

// MARK: - Searching
extension HomeCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        searchDataProvider.searchQuery = searchController.searchBar.text ?? ""
    }
}

