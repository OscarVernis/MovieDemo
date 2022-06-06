//
//  SearchViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class SearchViewController: ListViewController {
    var searchSection: SearchSection!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
    convenience init(coordinator: MainCoordinator?) {
        let section = SearchSection()
        self.init(section: section)
        self.searchSection = section
        self.coordinator = coordinator
    }
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: self)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
    
        return searchController
    }()
    
    fileprivate func setupSearch() {
        didSelectedItem = { [weak self] index in
            guard let self = self else { return }
            
            //Avoid the navigation bar showing after the Person Detail is shown
            self.searchController.hidesNavigationBarDuringPresentation = false

            let item = self.searchSection.dataProvider.item(atIndex: index)
            
            switch item {
            case let movie as MovieViewModel:
                self.coordinator?.showMovieDetail(movie: movie)
            case let person as PersonViewModel:
                self.coordinator?.showPersonProfile(person)
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
        if let listController = navigationItem.searchController?.searchResultsController as? ListViewController,
           listController.collectionView.cellForItem(at: firstIndexPath) != nil {
            listController.collectionView.scrollToItem(at: firstIndexPath, at: .top, animated: false)
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
       scrollListViewControllerToTop()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchQuery = searchController.searchBar.text {
            searchSection.dataProvider.query = searchQuery
        } else {
            scrollListViewControllerToTop()
        }
    }
    
}
