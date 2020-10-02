//
//  HomeCollectionViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Alamofire

class HomeCollectionViewController: UIViewController, GenericCollection {    
    var collectionView: UICollectionView!
    var dataSource: GenericCollectionDataSource!
    var searchDataProvider = MovieListDataProvider()
    
    weak var mainCoordinator: MainCoordinator!
    
    var didSelectItem: ((Movie) -> ())?
    
    var sections = [ConfigurableSection]()

    let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    //MARK:- Setup
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        createCollectionView()
        setup()
        setupSearch()
        setupDataSource()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    fileprivate func setup() {
        self.title = NSLocalizedString("Movies", comment: "")
        navigationController?.delegate = self

        //CollectionView setup
        collectionView.backgroundColor = .appBackgroundColor
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        //User Profile NavBar Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(showUser))
        
        //Network connection manager
        manager?.startListening { status in
            if status == .notReachable || status == .unknown {
                AlertManager.showNetworkConnectionAlert(sender: self)
            }
        }
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
    
    fileprivate func setupDataSource() {
        let sectionHeaderHandler: (HomeMovieListSection) -> Void = { [weak self] section in
            self?.showMovieList(section: section)
        }
        
        sections = [
            HomeMovieListSection(.NowPlaying, sectionHeaderButtonHandler: sectionHeaderHandler),
            HomeMovieListSection(.Upcoming, sectionHeaderButtonHandler: sectionHeaderHandler),
            HomeMovieListSection(.Popular, sectionHeaderButtonHandler: sectionHeaderHandler),
            HomeMovieListSection(.TopRated, sectionHeaderButtonHandler: sectionHeaderHandler)
        ]
        
        let dataSourceDidUpdate: (Int) -> Void = { [weak self] section in
            self?.collectionView.refreshControl?.endRefreshing()
            self?.collectionView.reloadData()
        }
        
        self.dataSource = GenericCollectionDataSource(collectionView: collectionView, sections: sections)
        dataSource.didUpdate = dataSourceDidUpdate
        
        refresh()
    }
    
    //MARK:- Actions
    @objc func showUser() {
        mainCoordinator.showUserProfile()
    }
    
    @objc func refresh() {
        dataSource.refresh()
    }
    
    func showMovieList(section: HomeMovieListSection) {
        let dataProvider = MovieListDataProvider(section.dataProvider.currentService)
        mainCoordinator.showMovieList(title: section.title, dataProvider: dataProvider)
    }
    
    //MARK: - CollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let section = sections[indexPath.section] as? HomeMovieListSection {
            let movie = section.dataProvider.movies[indexPath.row]
            
            mainCoordinator.showMovieDetail(movie: movie)
        }
    }
    
}

//MARK: - CollectionView CompositionalLayout
extension HomeCollectionViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let section = self.dataSource.sections[sectionIndex]
            return section.sectionLayout()
        }
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
        
        return layout
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
