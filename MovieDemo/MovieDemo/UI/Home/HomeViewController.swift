//
//  HomeViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, GenericCollection {    
    var collectionView: UICollectionView!
    var dataSource: GenericCollectionDataSource!
    
    weak var mainCoordinator: MainCoordinator!
    
    var didSelectItem: ((Movie) -> ())?
    
    var sections = [ConfigurableSection]()
    
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
        title = .localized(.Movies)
        navigationController?.delegate = self
        
        //CollectionView setup
        collectionView.backgroundColor = .asset(.AppBackgroundColor)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        //User Profile NavBar Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .asset(.person), style: .plain, target: self, action: #selector(showUser))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Restore search bar behavior after Person Detail is closed
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
    }
    
    fileprivate func setupSearch() {
        let searchViewController = SearchViewController(coordinator: mainCoordinator)
        navigationItem.searchController = searchViewController.searchController
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
extension HomeViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = (UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let section = self?.dataSource.sections[sectionIndex]
            return section?.sectionLayout()
        })
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
        
        return layout
    }

}
