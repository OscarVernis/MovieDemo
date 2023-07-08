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
        let layout = UICollectionViewCompositionalLayout(sectionProvider: UserProfileLayoutProvider(user: user).createLayout)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
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
        let topInset = UIWindow.mainWindow.topInset
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
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
    
    func configureTitleHeader(_ header: UICollectionReusableView, section: UserProfileDataSource.Section) {
        guard let titleHeader = header as? SectionTitleView else { return }
                
        titleHeader.tapHandler = { [weak self] in
            switch section {
            case .favorites:
                self?.mainCoordinator?.showUserFavorites()
            case .watchlist:
                self?.mainCoordinator?.showUserWatchlist()
            case .rated:
                self?.mainCoordinator?.showUserRated()
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
