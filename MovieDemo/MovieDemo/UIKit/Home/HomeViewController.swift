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
    
    var router: HomeRouter!
    
    var didSelectItem: ((Movie) -> ())?
    
    var nowPlayingProvider: MoviesProvider
    var upcomingProvider: MoviesProvider
    var popularProvider: MoviesProvider
    var topRatedProvider: MoviesProvider
        
    //MARK: - Setup
    required init(router: HomeRouter?,
                  nowPlayingProvider: MoviesProvider,
                  upcomingProvider: MoviesProvider,
                  popularProvider: MoviesProvider,
                  topRatedProvider: MoviesProvider) {
        self.router = router
        self.nowPlayingProvider = nowPlayingProvider
        self.upcomingProvider = upcomingProvider
        self.popularProvider = popularProvider
        self.topRatedProvider = topRatedProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        setupCollectionView()
        setupDataSource()
        setupViewController()
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
    
    fileprivate func setupDataSource() {
        self.dataSource = HomeDataSource(collectionView: self.collectionView,
        nowPlayingProvider: nowPlayingProvider,
        upcomingProvider: upcomingProvider,
        popularProvider: popularProvider,
        topRatedProvider: topRatedProvider)
        
        dataSource.didUpdate = { [weak self] section, _ in
            self?.collectionView.refreshControl?.endRefreshing()
        }
        collectionView.dataSource = dataSource
        
        refresh()
    }
    
    //MARK: - Actions
    @objc func showUser() {
        router.showUserProfile()
    }
    
    @objc func refresh() {
        dataSource.refresh()
    }
    
    func showMovieList(section: HomeDataSource.Section) {
        switch section {
        case .nowPlaying:
            router.showNowPlaying()
        case .upcoming:
            router.showUpcoming()
        case .popular:
            router.showPopular()
        case .topRated:
            router.showTopRated()
        }
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let titleHeader = view as? SectionTitleView else { return }
        
        titleHeader.tapHandler = { [weak self] in
            self?.showMovieList(section: .init(rawValue: indexPath.section)!)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let provider = dataSource.providers[indexPath.section]
        let movie = provider.item(atIndex: indexPath.row)
        
        router.showMovieDetail(movie: movie)
    }
    
}
