//
//  HomeViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {
    var collectionView: UICollectionView!
    var dataSource: HomeDataSource!
    
    weak var mainCoordinator: MainCoordinator!
    
    var didSelectItem: ((Movie) -> ())?
        
    //MARK: - Setup
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        setupCollectionView()
        setupDataSource()
        setupViewController()
        setupSearch()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: HomeLayoutProvider().createLayout)
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        //Setup
        collectionView.backgroundColor = .asset(.AppBackgroundColor)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        view.addSubview(collectionView)
    }
    
    fileprivate func setupViewController() {
        title = .localized(HomeString.Movies)
        navigationController?.delegate = self
        
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
        self.dataSource = HomeDataSource(collectionView: self.collectionView)
        dataSource.didUpdate = { [weak self] section, _ in
            self?.collectionView.refreshControl?.endRefreshing()
        }
        collectionView.dataSource = dataSource
        
        refresh()
    }
    
    //MARK: - Actions
    @objc func showUser() {
        mainCoordinator.showUserProfile()
    }
    
    @objc func refresh() {
        dataSource.refresh()
    }
    
    func showMovieList(title: String, provider: MoviesDataProvider) {
        mainCoordinator.showMovieList(title: title, dataProvider: provider)
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let titleHeader = view as? SectionTitleView else { return }
        
        let dataProvider = dataSource.providers[indexPath.section]
        let title = titleHeader.titleLabel.text ?? ""
        
        titleHeader.tapHandler = { [weak self] in
            self?.showMovieList(title: title, provider: dataProvider)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let provider = dataSource.providers[indexPath.section]
        let movie = provider.item(atIndex: indexPath.row)
        
        mainCoordinator.showMovieDetail(movie: movie)
    }
    
}
