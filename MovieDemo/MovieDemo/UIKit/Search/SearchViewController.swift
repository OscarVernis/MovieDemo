//
//  SearchViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class SearchViewController: DiffableListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
    fileprivate var searchRouter: SearchViewRouter? {
        router as? SearchViewRouter
    }
    
    init(dataSourceProvider: @escaping (UICollectionView) -> any PagingDataSource, router: SearchViewRouter?) {
        super.init(dataSourceProvider: dataSourceProvider, router: router)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSearch() {
        didSelectedItem = { [weak self] item in
            guard let self = self else { return }
            
            //Avoid the navigation bar showing after the Person Detail is shown
            self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
            
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
        if let searchQuery = searchController.searchBar.text, let searchDataSource = dataSource as? SearchDataSource {
            searchDataSource.query = searchQuery
        } else {
            scrollListViewControllerToTop()
        }
    }
    
}
