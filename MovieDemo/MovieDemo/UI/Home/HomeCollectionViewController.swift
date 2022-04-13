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
    var searchSection: SearchSection!
    
    weak var mainCoordinator: MainCoordinator!
    
    var didSelectItem: ((Movie) -> ())?
    
    var sections = [ConfigurableSection]()

    let manager = NetworkReachabilityManager(host: "www.google.com")
    
    //MARK: - Setup
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
        title = NSLocalizedString("Movies", comment: "")
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
    
    override func viewWillAppear(_ animated: Bool) {
        //Restore search bar behavior after Person Detail is closed
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
    }
    
    fileprivate func setupSearch() {
        searchSection = SearchSection()
        let movieListController = ListViewController(section: searchSection)

        movieListController.didSelectedItem = { [weak self] index in
            guard let self = self else { return }
            
            //Avoid the navigation bar showing after the Person Detail is shown
            self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false

            let item = self.searchSection.dataProvider.item(atIndex: index)
            
            switch item {
            case let movie as MovieViewModel:
                self.mainCoordinator.showMovieDetail(movie: movie)
            case let person as PersonViewModel:
                self.mainCoordinator.showPersonProfile(person)
            default:
                break
            }

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
                
        self.dataSource = GenericCollectionDataSource(collectionView: collectionView, sections: sections)
        dataSource.didUpdate = { [weak self] section in
            self?.collectionView.refreshControl?.endRefreshing()
            self?.collectionView.reloadData()
        }
        
        refresh()
    }
    
    //MARK: - Actions
    @objc func showUser() {
        mainCoordinator.showUserProfile()
    }
    
    @objc func refresh() {
        dataSource.refresh()
    }
    
    func showMovieList(section: HomeMovieListSection) {
        let dataProvider = MoviesDataProvider(section.dataProvider.currentService)
        mainCoordinator.showMovieList(title: section.title, dataProvider: dataProvider)
    }
    
    //MARK: - CollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let section = sections[indexPath.section] as? HomeMovieListSection {
            let movie = section.dataProvider.item(atIndex: indexPath.row)
            
            mainCoordinator.showMovieDetail(movie: movie)
        }
    }
    
}

//MARK: - CollectionView CompositionalLayout
extension HomeCollectionViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = (UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let section = self.dataSource.sections[sectionIndex]
            return section.sectionLayout()
        })
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
        
        return layout
    }

}

// MARK: - Searching
extension HomeCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate {
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
