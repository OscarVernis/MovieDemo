//
//  UserProfileViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class UserProfileViewController: UIViewController {
    var router: UserProfileRouter?
    
    var collectionView: UICollectionView!
    var dataSource: UserProfileDataSource!
    var layoutProvider: UserProfileLayoutProvider!
            
    private var store: UserProfileStore
    private var user: UserViewModel! {
        store.user
    }
    
    private var cancellables = Set<AnyCancellable>()

    //MARK: - View Controller
    init(store: UserProfileStore, router: UserProfileRouter? = nil) {
        self.router = router
        self.store = store
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        setupCustomBackButton()
        createCollectionView()
        setupCollectionView()
        setudDataSource()
        setupStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWithDefaultNavigationBarAppearance()
        store.updateUser()
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
    
    fileprivate func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }

            let section = UserProfileDataSource.Section(rawValue: sectionIndex)!
            let itemCount: Int
            switch section {
            case .header:
                itemCount = 0
            case .favorites:
                itemCount = user.favorites.count
            case .watchlist:
                itemCount = user.watchlist.count
            case .rated:
                itemCount = user.rated.count
            }
            
            return UserProfileLayoutProvider.layout(for: section, itemCount: itemCount)
        }

        return layout
    }
    
    fileprivate func setupCollectionView() {
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.delegate = self
        
        collectionView.backgroundColor = .asset(.AppBackgroundColor)
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        let topInset = UIWindow.mainWindow.topInset + 55
        let bottomInset = UIWindow.mainWindow.safeAreaInsets.bottom + 10
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
    }
    
    fileprivate func setudDataSource() {
        dataSource = UserProfileDataSource(collectionView: collectionView, supplementaryViewProvider: { [unowned self] collectionView, elementKind, indexPath in
            return header(with: collectionView, at: indexPath)
        })
        
        dataSource.registerReusableViews(collectionView: collectionView)
    }
    
    fileprivate func header(with collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = UserProfileDataSource.Section(rawValue: indexPath.section)!
        if section == .header {
            let userHeaderView = dataSource.userHeader(with: collectionView, at: indexPath)
            userHeaderView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
            
            return userHeaderView
        } else {
            let sectionTitleView = dataSource.titleHeader(with: collectionView, section: section, at: indexPath)
            configureTitleHeader(sectionTitleView, section: section)
            
            return sectionTitleView
        }
    }
    
    fileprivate func setupStore()  {
        store.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.storeDidUpdate()
        }
        .store(in: &cancellables)
        
        store.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
            if error != nil {
                self?.handleError()
                self?.store.error = nil
            }
        }
        .store(in: &cancellables)

        store.updateUser()
    }
    
}

//MARK: - Actions
extension UserProfileViewController {
    fileprivate func storeDidUpdate() {
        dataSource.user = user
        
        let showLoading = user.username.isEmpty
        dataSource.isLoading = showLoading ? store.isLoading : false
        dataSource.reload()
    }
    
    fileprivate func handleError() {
        router?.handle(error: .refreshError, shouldDismiss: true)
    }
    
    @objc fileprivate func logout() {
        router?.logout()
    }
    
    func showMovieDetail(at index: Int, from movies: [MovieViewModel]) {
        guard movies.count > 0 else { return }
        let movie = movies[index]
        router?.showMovieDetail(movie: movie)
    }
    
    func configureTitleHeader(_ header: UICollectionReusableView, section: UserProfileDataSource.Section) {
        guard let titleHeader = header as? SectionTitleView else { return }
        
        switch section {
        case .favorites:
            if user.favorites.count > 0 {
                titleHeader.tapHandler = { [weak self] in
                    self?.router?.showUserFavorites()
                }
            } else {
                titleHeader.tapHandler = nil
            }
        case .watchlist:
            if user.watchlist.count > 0 {
                titleHeader.tapHandler = { [weak self] in
                    self?.router?.showUserWatchlist()
                }
            } else {
                titleHeader.tapHandler = nil
            }
        case .rated:
            if user.rated.count > 0 {
                titleHeader.tapHandler = { [weak self] in
                    self?.router?.showUserRated()
                }
            } else {
                titleHeader.tapHandler = nil
            }
        default:
            break
        }
                
    }
    
}

//MARK: - UICollectionViewDelegate
extension UserProfileViewController: UICollectionViewDelegate {
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
