//
//  SearchViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    var listViewController: ListViewController!
    var store: SearchStore
    var router: SearchViewRouter?
    
    init(searchService: @escaping SearchService, router: SearchViewRouter? = nil) {
        self.store = SearchStore(searchService: searchService)
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupListViewController()
    }
    
    private func setupListViewController() {
        let dataSourceProvider = { [unowned self] in
            ProviderPagingDataSource(collectionView: $0, dataProvider: store.searchProvider, cellProvider: cellProvider)
        }
        listViewController = ListViewController(dataSourceProvider: dataSourceProvider, layout: ListViewController.loadingLayout(), router: router)
        
        listViewController.didSelectedItem = { [unowned self] item in
            //Avoid the navigation bar showing after the Person Detail is shown
            navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
            
            let searchItem = item as! SearchResultViewModel
            switch searchItem {
            case .movie(let movie):
                router?.showMovieDetail(movie: movie)
            case .person(let person):
                router?.showPersonProfile(person)
            }
        }
        
        listViewController.embed(in: self)
        registerViews(collectionView: listViewController.collectionView)
    }
    
    typealias DataSource = ProviderPagingDataSource<PaginatedProvider<SearchResultViewModel>, UICollectionViewCell>
    private lazy var cellProvider: DataSource.CellProvider = { [unowned self] collectionView, indexPath, item in
        let section = DataSource.Section(rawValue: indexPath.section)!
        switch section {
        case .main:
            return mainCell(collectionView: collectionView, for: item, at: indexPath)
        case .loading:
            return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
        }
    }
    
    private func mainCell(collectionView: UICollectionView, for item: AnyHashable, at indexPath: IndexPath) -> UICollectionViewCell {
        let searchItem = item as! SearchResultViewModel
        switch searchItem {
        case .movie(let movie):
            return collectionView.cell(at: indexPath, model: movie, cellConfigurator: MovieInfoListCell.configure)
        case .person(let person):
            return collectionView.cell(at: indexPath, model: person, cellConfigurator: CreditPhotoListCell.configure)
        }
    }
    
    private func registerViews(collectionView: UICollectionView) {
        MovieInfoListCell.register(to: collectionView)
        CreditPhotoListCell.register(to: collectionView)
        LoadingCell.register(to: collectionView)
    }
    
}

// MARK: - Searching
extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func scrollListViewControllerToTop() {
        //Scroll results list to top everytime is shown.
        let firstIndexPath = IndexPath(row: 0, section: 0)
        if listViewController.collectionView.cellForItem(at: firstIndexPath) != nil {
            listViewController.collectionView.scrollToItem(at: firstIndexPath, at: .top, animated: false)
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        scrollListViewControllerToTop()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchQuery = searchController.searchBar.text {
            store.query = searchQuery
        } else {
            scrollListViewControllerToTop()
        }
    }
    
}
