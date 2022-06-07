//
//  UserProfileViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, GenericCollection {
    weak var mainCoordinator: MainCoordinator?
    
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    private var bottomInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
    
    var collectionView: UICollectionView!
    var dataSource: GenericCollectionDataSource!
    
    private var sections: [ConfigurableSection]!
    
    private var user = UserViewModel()

    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            headerSection(loading: true)
        ]
                
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
    
    fileprivate func setupCollectionView() {
        //Set NavigationBar/ScrollView settings for design
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        dataSource = GenericCollectionDataSource(collectionView: collectionView, sections: sections)   
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
            
            self.reloadSections()
        }
        
        user.didUpdate = updateCollectionView
    }
    
    //MARK: - Section Loading
    fileprivate func headerSection(loading: Bool = false) -> UserProfileHeaderSection {
        let headerSection = UserProfileHeaderSection(user: user)
        headerSection.isLoading = loading
        headerSection.logoutButtonHandler = { [weak self] in
            self?.logout()
        }
        
        return headerSection
    }
    
    fileprivate func reloadSections() {        
        sections = [
            headerSection(),
            UserProfileMovieListSection(.Favorites, movies: user.favorites, coordinator: mainCoordinator),
            UserProfileMovieListSection(.Watchlist, movies: user.watchlist, coordinator: mainCoordinator),
            UserProfileMovieListSection(.Rated, movies: user.rated, coordinator: mainCoordinator),
        ]
        
        dataSource.sections = sections
        collectionView.reloadData()
    }
    
}

//MARK: - Actions
extension UserProfileViewController {
    fileprivate func logout() {
        mainCoordinator?.logout()
    }
}

//MARK: - UICollectionViewDelegate
extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let section = sections[indexPath.section] as? UserProfileMovieListSection, section.movies.count > 0 {
            let movie = section.movies[indexPath.row]
            mainCoordinator?.showMovieDetail(movie: movie)
        }
    }

}
