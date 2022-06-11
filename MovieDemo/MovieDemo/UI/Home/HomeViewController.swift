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
                        
        createCollectionView()
        setupDataSource()
        setup()
        setupSearch()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func createCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
    
    fileprivate func setup() {
        title = .localized(HomeString.Movies)
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
    
    func showMovieList(section: HomeMovieListSection) {
        let dataProvider = MoviesDataProvider(section.dataProvider.currentService)
        mainCoordinator.showMovieList(title: section.title, dataProvider: dataProvider)
    }
    
    //MARK: - CollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let provider = dataSource.providers[indexPath.section] 
        let movie = provider.item(atIndex: indexPath.row)
        
        mainCoordinator.showMovieDetail(movie: movie)
        
    }
    
}

//MARK: - CollectionView CompositionalLayout
extension HomeViewController {

    func createLayout() -> UICollectionViewLayout {
        let layout = (UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch(sectionIndex) {
            case 0:
                return self?.makeBannerSection()
            case 1:
                return self?.makeHorizontalPosterSection()
            case 2:
                return self?.makeListSection()
            case 3:
                return self?.makeDecoratedListSection()
            default:
                return nil
            }
        })
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.elementKind)
        
        return layout
    }
    
    func makeBannerSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        section = sectionBuilder.createBannerSection()
        section.contentInsets.top = 10
        section.contentInsets.bottom = 10
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeHorizontalPosterSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        section = sectionBuilder.createHorizontalPosterSection()
        section.contentInsets.top = 10
        section.contentInsets.bottom = 20
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeListSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        section = sectionBuilder.createListSection()
        section.contentInsets.bottom = 30
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }

    func makeDecoratedListSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        section = sectionBuilder.createDecoratedListSection()
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
