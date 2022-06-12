//
//  UserProfileDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
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
        
        super.init(dataSources: [])
        
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
            makeHeader(),
            makeFavorites(),
            makeWatchlist(),
            makeRated()
        ]
    }
    
    //MARK: - Data Sources
    func makeHeader() -> UICollectionViewDataSource {
        UserHeaderDataSource(user: user)
    }
    
    func makeTitleHeader(title: String, dataSource: UICollectionViewDataSource) -> UICollectionViewDataSource {
        let titleDataSource = TitleHeaderDataSource(title: title,
                                                    dataSource: dataSource) { title, header in
            guard let header = header as? SectionTitleView else { return }
            MovieDetailTitleSectionConfigurator().configure(headerView: header, title: title)
        }
        
        return titleDataSource
    }
    
    func makeFavorites() -> UICollectionViewDataSource {
        let dataSource = UserMoviesDataSource(models: user.favorites, emptyMessage: emptyMessage(for: .favorites))
        
        let titleDataSource = makeTitleHeader(title: .localized(UserString.Favorites), dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeWatchlist() -> UICollectionViewDataSource {
        let dataSource = UserMoviesDataSource(models: user.watchlist, emptyMessage: emptyMessage(for: .watchlist))
        
        let titleDataSource = makeTitleHeader(title: .localized(UserString.Watchlist), dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeRated() -> UICollectionViewDataSource {
        let dataSource = UserMoviesDataSource(models: user.rated, emptyMessage: emptyMessage(for: .rated))
        
        let titleDataSource = makeTitleHeader(title: .localized(UserString.Rated), dataSource: dataSource)

        
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
