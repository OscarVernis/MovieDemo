//
//  UserProfileDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileDataSource: UICollectionViewDiffableDataSource<UserProfileDataSource.Section, AnyHashable> {
    enum Section: Int, CaseIterable {
        case header, favorites, watchlist, rated
    }
    
    struct UserSectionItem: Hashable {
        let section: Section
        let movie: MovieViewModel
    }
    
    var user: UserViewModel!
    var isLoading = false
    
    //MARK: - Cell Setup
    func registerReusableViews(collectionView: UICollectionView) {
        UserProfileHeaderView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(to: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
        EmptyMovieCell.register(to: collectionView)
    }
    
    func cell(for collectionView: UICollectionView, with indexPath: IndexPath, identifier: AnyHashable) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .header:
            return loadingCell(at: indexPath, with: collectionView)
        case .favorites:
            return favoriteCell(at: indexPath, model: identifier, with: collectionView)
        case .watchlist:
            return watchlistCell(at: indexPath, model: identifier, with: collectionView)
        case .rated:
            return ratedCell(at: indexPath, model: identifier, with: collectionView)
        }
    }
    
    private func loadingCell(at indexPath: IndexPath, with collectionView: UICollectionView) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
    }
    
    private func favoriteCell(at indexPath: IndexPath, model: AnyHashable, with collectionView: UICollectionView) -> UICollectionViewCell {
        if user.favorites.isEmpty {
            return emptyCell(at: indexPath, message: AttributedStringAsset.emptyFavoritesMessage, with: collectionView)
        } else {
            return movieCell(at: indexPath, model: model, with: collectionView)
        }
    }
    
    private func watchlistCell(at indexPath: IndexPath, model: AnyHashable, with collectionView: UICollectionView) -> UICollectionViewCell {
        if user.watchlist.isEmpty {
            return emptyCell(at: indexPath, message: AttributedStringAsset.emptyWatchlistMessage, with: collectionView)
        } else {
            return movieCell(at: indexPath, model: model, with: collectionView)
        }
    }
    
    private func ratedCell(at indexPath: IndexPath, model: AnyHashable, with collectionView: UICollectionView) -> UICollectionViewCell {
        if user.rated.isEmpty {
            return emptyCell(at: indexPath, message: AttributedStringAsset.emptyRatedMessage, with: collectionView)
        } else {
            return movieCell(at: indexPath, model: model, with: collectionView)
        }
    }
    
    private func emptyCell(at indexPath: IndexPath, message: NSAttributedString, with collectionView: UICollectionView) -> UICollectionViewCell {
        let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyMovieCell.reuseIdentifier, for: indexPath) as! EmptyMovieCell
        
        emptyCell.configure(message: message)
        
        return emptyCell
    }
    
    private func movieCell(at indexPath: IndexPath, model: AnyHashable, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
        let movie = (model as! UserSectionItem).movie
        MoviePosterInfoCell.configureWithRating(cell: cell, with: movie)
        return cell
    }
    
    //MARK: - Reload
    func reload(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<UserProfileDataSource.Section, AnyHashable>()
        
        snapshot.appendSections(Section.allCases)
        if isLoading {
            let loadingItemId = UUID().uuidString
            snapshot.appendItems([loadingItemId], toSection: .header)
        }
        
        if user.favorites.isEmpty {
            let emptyFavoritesItemId = UUID().uuidString
            snapshot.appendItems([emptyFavoritesItemId], toSection: .favorites)
        } else {
            let favoriteItems = user.favorites.map { UserSectionItem(section: .favorites, movie: $0) }
            snapshot.appendItems(favoriteItems, toSection: .favorites)
        }
        
        if user.watchlist.isEmpty {
            let emptyWatchlistItemId = UUID().uuidString
            snapshot.appendItems([emptyWatchlistItemId], toSection: .watchlist)
        } else {
            let watchlistItems = user.watchlist.map { UserSectionItem(section: .watchlist, movie: $0) }
            snapshot.appendItems(watchlistItems, toSection: .watchlist)
        }
        
        if user.rated.isEmpty {
            let emptyRatedItemId = UUID().uuidString
            snapshot.appendItems([emptyRatedItemId], toSection: .rated)
        } else {
            let ratedItems = user.rated.map { UserSectionItem(section: .rated, movie: $0) }
            snapshot.appendItems(ratedItems, toSection: .rated)
        }
        
        snapshot.reloadSections([.header])
        apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: - Header Data Source
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = Section(rawValue: indexPath.section)!
        let header: UICollectionReusableView
        if section == .header {
            let userHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeaderView.reuseIdentifier, for: indexPath) as! UserProfileHeaderView
            
            //Adjust the top of the Header so it doesn't go unde the bar
            userHeaderView.topConstraint.constant = UIWindow.mainWindow.topInset + 55
            
            userHeaderView.configure(user: user)
            
            header = userHeaderView
        } else {
            let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            
            SectionTitleView.configureForDetail(headerView: sectionTitleView,
                                                title: title(for: section),
                                                image: image(for: section))
            
            header = sectionTitleView
        }
        
        return header
    }
    
    private func title(for section: Section) -> String {
        switch section {
        case .header:
            return ""
        case .favorites:
            return .localized(UserString.Favorites)
        case .watchlist:
            return .localized(UserString.Watchlist)
        case .rated:
            return .localized(UserString.Rated)
        }
    }
    
    private func image(for section: Section) -> UIImage? {
        switch section {
        case .header:
            return nil
        case .favorites:
            return UIImage.asset(.heart).withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        case .watchlist:
            return UIImage.asset(.bookmark).withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        case .rated:
            return UIImage.asset(.star).withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        }
    }
    
}
