//
//  HomeViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UICollectionViewDelegate {
    var collectionView: UICollectionView!
    var dataSource: HomeDataSource!
    
    var router: HomeRouter!
    
    var didSelectItem: ((Movie) -> ())?
    
    var cancellables = Set<AnyCancellable>()
    
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
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        setupCollectionView()
        setupDataSource()
        setupProviders()
        refresh()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: HomeLayoutProvider.createLayout)
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.delegate = self
        
        //Setup
        collectionView.backgroundColor = .asset(.AppBackgroundColor)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        view.addSubview(collectionView)
    }
    
    fileprivate func setupViewController() {
        title = .localized(HomeString.Movies)
    }
    
    fileprivate func setupNavigationBar() {
        configureWithDefaultNavigationBarAppearance()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .asset(.AppTintColor)
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)!
        ]
        navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-Bold", size: 34)!,
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Restore search bar behavior after Person Detail is closed
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
        
        setupNavigationBar()
    }
    
    //MARK: - DataSource
    fileprivate func setupDataSource() {
        dataSource = HomeDataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            return self.dataSource.cell(for: collectionView, with: indexPath, identifier: itemIdentifier)
        })
        
        dataSource.registerReusableViews(collectionView: collectionView)
    }
    
    fileprivate func setupProviders() {
        subscribe(to: nowPlayingProvider.$items)
        subscribe(to: upcomingProvider.$items)
        subscribe(to: popularProvider.$items)
        subscribe(to: topRatedProvider.$items)
    }
    
    fileprivate func subscribe(to publisher: Published<[MovieViewModel]>.Publisher) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadDataSource()
            }
            .store(in: &cancellables)
    }
    
    fileprivate func reloadDataSource() {
        collectionView.refreshControl?.endRefreshing()

        var snapshot = NSDiffableDataSourceSnapshot<HomeDataSource.Section, HomeSectionMovie>()
        
        snapshot.appendSections(HomeDataSource.Section.allCases)
        
        let nowPlayingItems = nowPlayingProvider.items.map { HomeSectionMovie(section: .nowPlaying, movie: $0) }
        snapshot.appendItems(nowPlayingItems, toSection: .nowPlaying)
        
        let upcomingItems = upcomingProvider.items.map { HomeSectionMovie(section: .upcoming, movie: $0) }
        snapshot.appendItems(upcomingItems, toSection: .upcoming)
        
        let popularItems = popularProvider.items.map { HomeSectionMovie(section: .popular, movie: $0) }
        snapshot.appendItems(popularItems, toSection: .popular)
        
        let maxTopRated = min(dataSource.maxTopRated, topRatedProvider.items.count)
        let topRatedItems = topRatedProvider.items[0..<maxTopRated].map { HomeSectionMovie(section: .topRated, movie: $0) }
        snapshot.appendItems(topRatedItems, toSection: .topRated)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc fileprivate func refresh() {
        nowPlayingProvider.refresh()
        upcomingProvider.refresh()
        popularProvider.refresh()
        topRatedProvider.refresh()
    }
    
    //MARK: - Actions
    fileprivate func showMovieList(section: HomeDataSource.Section) {
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
        if let movie = dataSource.itemIdentifier(for: indexPath)?.movie {
            router.showMovieDetail(movie: movie)
        }
    }
    
}
