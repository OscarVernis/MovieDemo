//
//  UserProfileDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileDataSource: SectionedCollectionDataSource {
    enum Section: Int, CaseIterable {
        case header, favorites, watchlist, rated
    }
    
    unowned var collectionView: UICollectionView
    let user: UserViewModel
    
    init(collectionView: UICollectionView, user: UserViewModel) {
        self.collectionView = collectionView
        self.user = user
        
        super.init()
        
        registerReusableViews()
        setupDataSources()
    }
    
    func reload() {
        setupDataSources()
    }
    
    //MARK: - Setup
    func registerReusableViews() {
        UserProfileHeaderView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(to: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
        EmptyMovieCell.register(to: collectionView)
    }
    
    func setupDataSources() {
        dataSources = [
            makeUserHeader(),
            makeFavorites(),
            makeWatchlist(),
            makeRated()
        ]
    }
    
    //MARK: - Data Sources
    func makeUserHeader() -> UICollectionViewDataSource {
        UserHeaderDataSource(user: user)
    }
    
    func makeFavorites() -> UICollectionViewDataSource {
        makeSection(models: user.favorites,
                    title: .localized(UserString.Favorites),
                    emptyMessage: emptyMessage(for: .favorites))
    }
    
    func makeWatchlist() -> UICollectionViewDataSource {
        makeSection(models: user.watchlist,
                    title: .localized(UserString.Watchlist),
                    emptyMessage: emptyMessage(for: .watchlist))
    }
    
    func makeRated() -> UICollectionViewDataSource {
        makeSection(models: user.rated,
                    title: .localized(UserString.Rated),
                    emptyMessage: emptyMessage(for: .rated))
    }
    
    //MARK: Helper
    func makeSection(models: [MovieViewModel], title: String, emptyMessage: NSAttributedString) -> UICollectionViewDataSource {
        let dataSource = UserMoviesDataSource(models: models, emptyMessage: emptyMessage)
        
        let titleDataSource = TitleHeaderDataSource(title: title,
                                                    dataSource: dataSource,
                                                    headerConfigurator: SectionTitleView.configureForDetail)
        return titleDataSource
        
    }
    
    //MARK: - Header Data Source
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: 0)

        return dataSource.collectionView!(collectionView, viewForSupplementaryElementOfKind: kind, at:indexPath)
    }
    
    //MARK: - Helper
    fileprivate func emptyMessage(for section: Section) -> NSAttributedString {
        var messageString = NSAttributedString()
        switch section {
        case .favorites:
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = .asset(.heart).withTintColor(.asset(.FavoriteColor))

            let fullString = NSMutableAttributedString(string: .localized(UserString.EmptyUserFavorites))
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: .localized(UserString.WillAppearMessage)))
            messageString = fullString
        case .watchlist:
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = .asset(.bookmark).withTintColor(.asset(.WatchlistColor))
            
            let fullString = NSMutableAttributedString(string: .localized(UserString.EmptyUserWatchlist))
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: .localized(UserString.WillAppearMessage)))

            messageString = fullString
        case .rated:
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = .asset(.star).withTintColor(.asset(.RatingColor))

            let fullString = NSMutableAttributedString(string: .localized(UserString.EmptyUserRated))
            fullString.append(NSAttributedString(attachment: imageAttachment))
            fullString.append(NSAttributedString(string: .localized(UserString.WillAppearMessage)))
            messageString = fullString
        default:
            messageString = NSAttributedString()
        }

        return messageString
    }
    
}
