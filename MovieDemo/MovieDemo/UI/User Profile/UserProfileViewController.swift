//
//  UserProfileViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    weak var mainCoordinator: MainCoordinator?
    
    var collectionView: UICollectionView!
    var dataSource: UserProfileDataSource!
    
    let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
    private var user: UserViewModel

    //MARK: - View Controller
    init(user: UserViewModel, coordinator: MainCoordinator? = nil) {
        self.mainCoordinator = coordinator
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        createCollectionView()
        setupCollectionView()
        setupDataProvider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user.updateUser()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Setup
    func createCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
    
    fileprivate func setupCollectionView() {
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: UIWindow.topInset, left: 0, bottom: 0, right: 0)
        
        dataSource = UserProfileDataSource(collectionView: collectionView, user: user)
        collectionView.dataSource = dataSource
    }
    
    fileprivate func setupDataProvider()  {
        let updateCollectionView:(Error?) -> () = { [weak self] error in
            guard let self = self else { return }
            
            
            //Load Blur Background
            if let imageURL = self.user.avatarURL {
                self.collectionView.backgroundColor = .clear

                let bgView = BlurBackgroundView.namedNib().instantiate(withOwner: nil, options: nil).first as! BlurBackgroundView

                bgView.imageView.setRemoteImage(withURL: imageURL)
                self.collectionView.backgroundView = bgView
            }
            
            if error != nil {
                self.mainCoordinator?.handle(error: .refreshError, shouldDismiss: true)
            }
            
            self.dataSource.reload()
            self.collectionView.reloadData()
        }
        
        user.didUpdate = updateCollectionView
    }
    
}

//MARK: - Actions
extension UserProfileViewController {
    @objc fileprivate func logout() {
        mainCoordinator?.logout()
    }
    
    func showMovieDetail(at index: Int, from movies: [MovieViewModel]) {
        guard movies.count > 0 else { return }
        let movie = movies[index]
        mainCoordinator?.showMovieDetail(movie: movie)
    }
    
    func configureTitleHeader(_ header: UICollectionReusableView, list: MovieList) {
        guard let titleHeader = header as? SectionTitleView else { return }
        
        let title = titleHeader.titleLabel.text ?? ""
        
        titleHeader.tapHandler = { [weak self] in
            self?.mainCoordinator?.showMovieList(title: title, list: list)
        }
    }
    
}

//MARK: - UICollectionViewDelegate
extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let section = UserProfileDataSource.Section(rawValue: indexPath.section)!

        switch section {
        case .header:
            guard let header = view as? UserProfileHeaderView else { return }
            header.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        case .favorites:
            configureTitleHeader(view, list: .UserFavorites)
        case .watchlist:
            configureTitleHeader(view, list: .UserWatchList)
        case .rated:
            configureTitleHeader(view, list: .UserRated)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = UserProfileDataSource.Section(rawValue: indexPath.section)!
        switch section {
        case .favorites:
            showMovieDetail(at: indexPath.row, from: user.favorites)
        case .watchlist:
            showMovieDetail(at: indexPath.row, from: user.watchlist)
        case .rated:
            showMovieDetail(at: indexPath.row, from: user.rated)
        default:
            break
        }
    }

}

//MARK: - CollectionView CompositionalLayout
extension UserProfileViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = UserProfileDataSource.Section(rawValue: sectionIndex)!
            
            switch section {
            case .header:
                return self.makeHeaderSection()
            case .favorites:
                return (self.user.favorites.count > 0) ? self.makeMoviesSection() : self.makeEmptySection()
            case .watchlist:
                return (self.user.watchlist.count > 0) ? self.makeMoviesSection() : self.makeEmptySection()
            case .rated:
                return (self.user.rated.count > 0) ? self.makeMoviesSection() : self.makeEmptySection()
            }
        }
        
        return layout
    }
    
    
    func makeHeaderSection() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createSection(groupHeight: .estimated(150))
        
        let sectionHeader = sectionBuilder.createDetailSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeMoviesSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createHorizontalPosterSection()
        
        return makeTitleSection(with: section)
    }
    
    func makeEmptySection() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createSection(groupHeight: .estimated(260))
        section.contentInsets.top = 10
        section.contentInsets.bottom = 20
        
        return makeTitleSection(with: section)
    }
    
    func makeTitleSection(with section: NSCollectionLayoutSection) -> NSCollectionLayoutSection {
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
