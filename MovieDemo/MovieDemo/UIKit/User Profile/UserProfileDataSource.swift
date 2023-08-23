//
//  UserProfileDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileDataSource {
    enum Section: Int, CaseIterable {
        case header, favorites, watchlist, rated
    }
    
    struct UserSectionItem: Hashable {
        let section: Section
        let movie: MovieViewModel
    }
    
    var user: UserViewModel!
    var isLoading = false
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    init(collectionView: UICollectionView, supplementaryViewProvider: UICollectionViewDiffableDataSource<Section, AnyHashable>.SupplementaryViewProvider?) {
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            
            self.cell(for: collectionView, with: indexPath, identifier: itemIdentifier)
        })
        
        dataSource.supplementaryViewProvider = supplementaryViewProvider
        
        registerReusableViews(collectionView: collectionView)
    }
    
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
            return emptyOrMovieCell(with: collectionView,
                                    at: indexPath,
                                    model: identifier,
                                    isEmpty: user.favorites.isEmpty,
                                    emptyMessage: AttributedStringAsset.emptyFavoritesMessage)
        case .watchlist:
            return emptyOrMovieCell(with: collectionView,
                                    at: indexPath,
                                    model: identifier,
                                    isEmpty: user.watchlist.isEmpty,
                                    emptyMessage: AttributedStringAsset.emptyWatchlistMessage)
        case .rated:
            return emptyOrMovieCell(with: collectionView,
                                    at: indexPath,
                                    model: identifier,
                                    isEmpty: user.rated.isEmpty,
                                    emptyMessage: AttributedStringAsset.emptyRatedMessage)
        }
    }
    
    private func loadingCell(at indexPath: IndexPath, with collectionView: UICollectionView) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
    }
    
    private func emptyOrMovieCell(with collectionView: UICollectionView, at indexPath: IndexPath, model: AnyHashable, isEmpty: Bool, emptyMessage: NSAttributedString) -> UICollectionViewCell {
        if isEmpty {
            return collectionView.cell(at: indexPath, model: emptyMessage, cellConfigurator: EmptyMovieCell.configure)
        } else {
            let movie = (model as! UserSectionItem).movie
            return collectionView.cell(at: indexPath, model: movie, cellConfigurator: MoviePosterInfoCell.configureWithRating)
        }
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
        
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    //MARK: - Header Data Source
    func userHeader(with collectionView: UICollectionView, at indexPath: IndexPath) -> UserProfileHeaderView {
        let userHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeaderView.reuseIdentifier, for: indexPath) as! UserProfileHeaderView
        userHeaderView.configure(user: user)
        
        return userHeaderView
    }
    
    func titleHeader(with collectionView: UICollectionView, section: Section, at indexPath: IndexPath) -> SectionTitleView {
        let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
        
        SectionTitleView.configureForDetail(headerView: sectionTitleView,
                                            title: title(for: section))
        
        return sectionTitleView
    }
    
    func title(for section: Section) -> String {
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
    
    func image(for section: Section) -> UIImage? {
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
