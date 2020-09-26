//
//  UserProfileViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    weak var mainCoordinator: MainCoordinator!
    
    private var topInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    private var bottomInset = UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
    
    enum Section: Int, CaseIterable {
        case Header
        case Favorites
        case Watchlist
        case Rated
        
        var title: String {
            switch self {
            case .Header:
                return ""
            case .Favorites:
                return NSLocalizedString("Favorites", comment: "")
            case .Watchlist:
                return NSLocalizedString("Watchlist", comment: "")
            case .Rated:
                return NSLocalizedString("Rated", comment: "")
            }
        }
        
    }
    
    private var sections: [Section]!
    private var isLoading = true
    
    private var user = UserViewModel()
    private var collectionView: UICollectionView!
    
    //MARK:- Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            .Header,
        ]
        
        setupCollectionView()
        setupDataProvider()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        user.updateUser()
    }
    
    fileprivate func reloadSections() {
        sections = [
            .Header,
            .Favorites,
            .Watchlist,
            .Rated
        ]
        
        isLoading = false
        collectionView.reloadData()
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .appBackgroundColor
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Set NavigationBar/ScrollView settings for design
        self.navigationItem.largeTitleDisplayMode = .always
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        
        //Set so the scrollIndicator stops before the status bar
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        
        //Register Cells and Headers
        UserProfileHeaderView.registerHeader(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(withCollectionView: collectionView)
        MoviePosterInfoCell.register(withCollectionView: collectionView)
        EmptyMovieCell.register(withCollectionView: collectionView)
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    fileprivate func setupDataProvider()  {
        let updateCollectionView:(Error?) -> () = { [weak self] error in
            guard let self = self else { return }
            
            //Load Blur Background
            if let imageURL = self.user.avatarURL {
                self.collectionView.backgroundColor = .clear

                let bgView = BlurBackgroundView.namedNib().instantiate(withOwner: nil, options: nil).first as! BlurBackgroundView

                bgView.imageView.af.setImage(withURL: imageURL)
                self.collectionView.backgroundView = bgView
            }
            
            if error != nil {
                AlertManager.showRefreshErrorAlert(sender: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            self.reloadSections()
        }
        
        user.didUpdate = updateCollectionView
        user.updateUser()
    }
    
}

//MARK: - Actions
extension UserProfileViewController {
    fileprivate func logout() {
        mainCoordinator.logout()
    }
}

//MARK: - CollectionView CompositionalLayout
extension UserProfileViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            
            var section: NSCollectionLayoutSection?
            let sectionBuilder = MoviesCompositionalLayoutBuilder()
            
            let sectionType = self.sections[sectionIndex]
            
            switch sectionType {
            case .Header: //This is a dummy section used to contain the main header, it will not display any items
                section = sectionBuilder.createWideSection(withHeight: 150)
                
                let sectionHeader = sectionBuilder.createMovieDetailSectionHeader()
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Favorites:
                if self.user.favorites.count > 0 {
                    section = sectionBuilder.createHorizontalPosterSection()
                } else {
                    section = sectionBuilder.createWideSection(withHeight: 260)
                    section?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
                }
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.contentInsets.top = 12
                section?.contentInsets.bottom = 10
                section?.boundarySupplementaryItems = [sectionHeader]
            case .Watchlist:
                if self.user.watchlist.count > 0 {
                    section = sectionBuilder.createHorizontalPosterSection()
                } else {
                    section = sectionBuilder.createWideSection(withHeight: 260)
                    section?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
                }
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.contentInsets.top = 12
                section?.contentInsets.bottom = 10
                section?.boundarySupplementaryItems = [sectionHeader]
                
            case .Rated:
                if self.user.rated.count > 0 {
                    section = sectionBuilder.createHorizontalPosterSection()
                } else {
                    section = sectionBuilder.createWideSection(withHeight: 260)
                    section?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
                }
                
                let sectionHeader = sectionBuilder.createTitleSectionHeader()
                section?.contentInsets.top = 12
                section?.contentInsets.bottom = 10
                section?.boundarySupplementaryItems = [sectionHeader]
            }
            return section
        }
        
        return layout
    }
    
}

// MARK: UICollectionViewDelegate
extension UserProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .Header:
            break
        case .Favorites:
            let movie = user.favorites[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
            break
        case .Watchlist:
            let movie = user.watchlist[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
            break
        case .Rated:
            let movie = user.rated[indexPath.row]
            mainCoordinator.showMovieDetail(movie: movie)
            break
        }
    }
}

// MARK: Utils
extension UserProfileViewController {
    fileprivate func emptyCell(forSection section: Section, indexPath: IndexPath) -> EmptyMovieCell {
        let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyMovieCell.reuseIdentifier, for: indexPath) as! EmptyMovieCell
        
        emptyCell.configure(message: emptyMessageForSection(section: section))
        
        return emptyCell
    }
    
    fileprivate func emptyMessageForSection(section: Section) -> NSAttributedString {
        var messageString = NSAttributedString()
        switch section {
        case .Header:
            break
        case .Favorites:
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "heart.fill")?.withTintColor(.favoriteColor)

            let fullString = NSMutableAttributedString(string: NSLocalizedString("Movies you mark as Favorite ", comment: ""))
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: NSLocalizedString(" will appear here.", comment: "")))
            messageString = fullString
        case .Watchlist:
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "bookmark.fill")?.withTintColor(.watchlistColor)
            let fullString = NSMutableAttributedString(string: NSLocalizedString("Movies you add to your Watchlist ", comment: ""))
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: NSLocalizedString(" will appear here.", comment: "")))

            messageString = fullString
            break
        case .Rated:
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.ratingColor)

            let fullString = NSMutableAttributedString(string: NSLocalizedString("Movies you rate ", comment: ""))
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: NSLocalizedString(" will appear here.", comment: "")))
            messageString = fullString
            break
        }
        
        return messageString
    }
    
}

// MARK: UICollectionViewDataSource
extension UserProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = self.sections[section]
        switch sectionType {
        case .Header:
            return isLoading ? 1 : 0 //Dummy section to show Header, if loading shows LoadingCell
        case .Favorites:
            return user.favorites.count > 0 ? user.favorites.count : 1
        case .Watchlist:
            return user.watchlist.count > 0 ? user.watchlist.count : 1
        case .Rated:
            return user.rated.count > 0 ? user.rated.count : 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = self.sections[indexPath.section]
        switch sectionType {
        case .Header:
            if isLoading {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
                
                return cell
            } else {
                fatalError("Should be empty!")
            }
        case .Favorites:
            if user.favorites.count > 0 {
                let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
                
                let movie = user.favorites[indexPath.row]
                
                MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: movie))
                
                return posterCell
            } else {
                return emptyCell(forSection: .Favorites, indexPath: indexPath)
            }
        case .Watchlist:
            if user.watchlist.count > 0 {
                let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
                
                let movie = user.watchlist[indexPath.row]
                
                MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: movie))
                
                return posterCell
            } else {
                return emptyCell(forSection: .Watchlist, indexPath: indexPath)
            }
        case .Rated:
            if user.rated.count > 0 {
                let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
                
                let movie = user.rated[indexPath.row]
                
                MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: movie))
                
                return posterCell
            } else {
                return emptyCell(forSection: .Rated, indexPath: indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = self.sections[indexPath.section]
        
        if sectionType == .Header {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeaderView.reuseIdentifier, for: indexPath) as! UserProfileHeaderView
            
            //Adjust the top of the Poster Image so it doesn't go unde the bar
            headerView.topConstraint.constant = topInset + 55
            headerView.logoutButtonHandler = { [weak self] in
                self?.logout()
            }
            
            headerView.configure(user: user)
            
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            var tapHandler: (() -> ())?
            switch sectionType {
            case .Header:
                break
            case .Favorites:
                if user.favorites.count == 0 { break }
                
                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showMovieList(title: sectionType.title, dataProvider: MovieListDataProvider(.UserFavorites))
                }
            case .Watchlist:
                if user.watchlist.count == 0 { break }

                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showMovieList(title: sectionType.title, dataProvider: MovieListDataProvider(.UserWatchList))

                }
            case .Rated:
                if user.rated.count == 0 { break }
                
                tapHandler = { [weak self] in
                    guard let self = self else { return }
                    
                    self.mainCoordinator.showMovieList(title: sectionType.title, dataProvider: MovieListDataProvider(.UserRated))
                }
            }
            
            MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: sectionType.title, tapHandler: tapHandler)
            
            return headerView
        }
    }

}
