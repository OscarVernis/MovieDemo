//
//  SearchViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class SearchViewController: ListViewController<SearchProvider, UICollectionViewCell> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearch()
    }
    
    fileprivate var searchRouter: SearchViewRouter? {
        router as? SearchViewRouter
    }
    
    init(router: SearchViewRouter?) {
        let searchDataSource = SearchDataSource()
        super.init(dataSource: searchDataSource, router: router)
        self.provider = searchDataSource.dataProvider
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: self)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
    
        return searchController
    }()
    
    fileprivate func setupCollectionView() {
        MovieInfoListCell.register(to: collectionView)
        CreditPhotoListCell.register(to: collectionView)
    }
    
    fileprivate func setupSearch() {
        didSelectedItem = { [weak self] index in
            guard let self = self else { return }
            
            //Avoid the navigation bar showing after the Person Detail is shown
            self.searchController.hidesNavigationBarDuringPresentation = false

            let item = self.provider.item(atIndex: index)
            
            switch item {
            case let movie as MovieViewModel:
                self.searchRouter?.showMovieDetail(movie: movie)
            case let person as PersonViewModel:
                self.searchRouter?.showPersonProfile(person)
            default:
                break
            }
        }
    }
    
    override func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
        let section = sectionBuilder.createListSection()
        section.contentInsets.bottom = 30
        
        return section
    }
    
}

// MARK: - Searching
extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func scrollListViewControllerToTop() {
        //Scroll results list to top everytime is shown.
        let firstIndexPath = IndexPath(row: 0, section: 0)
        if self.collectionView.cellForItem(at: firstIndexPath) != nil {
            self.collectionView.scrollToItem(at: firstIndexPath, at: .top, animated: false)
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
       scrollListViewControllerToTop()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchQuery = searchController.searchBar.text {
            provider.query = searchQuery
        } else {
            scrollListViewControllerToTop()
        }
    }
    
}
