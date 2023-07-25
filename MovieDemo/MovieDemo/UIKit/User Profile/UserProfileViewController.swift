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
        setupStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.updateUser()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Setup
    func createCollectionView() {
        layoutProvider = UserProfileLayoutProvider(user: user)
        let layout = UICollectionViewCompositionalLayout { [weak self] section, enviroment in
            self?.layoutProvider.createLayout(sectionIndex: section, layoutEnvironment: enviroment)
        }
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
    
    fileprivate func setupCollectionView() {
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.delegate = self
        
        collectionView.backgroundColor = .asset(.AppBackgroundColor)
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        let topInset = UIWindow.mainWindow.topInset
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        dataSource = UserProfileDataSource(collectionView: collectionView, user: user, isLoading: store.isLoading)
        collectionView.dataSource = dataSource
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
        layoutProvider.user = user
        dataSource.user = user
        dataSource.reload()
        collectionView.reloadData()
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
                
        titleHeader.tapHandler = { [weak self] in
            switch section {
            case .favorites:
                self?.router?.showUserFavorites()
            case .watchlist:
                self?.router?.showUserWatchlist()
            case .rated:
                self?.router?.showUserRated()
            default:
                break
            }
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
            configureTitleHeader(view, section: section)
        case .watchlist:
            configureTitleHeader(view, section: section)
        case .rated:
            configureTitleHeader(view, section: section)
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
