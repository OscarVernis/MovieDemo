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
    fileprivate func registerReusableViews() {
        UserProfileHeaderView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(to: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
        EmptyMovieCell.register(to: collectionView)
    }
    
    fileprivate func setupDataSources() {
        dataSources = [
            makeUserHeader(),
            makeFavorites(),
            makeWatchlist(),
            makeRated()
        ]
    }
    
    //MARK: - Data Sources
    fileprivate func makeUserHeader() -> UICollectionViewDataSource {
        UserHeaderDataSource(user: user)
    }
    
    fileprivate func makeFavorites() -> UICollectionViewDataSource {
        makeSection(models: user.favorites,
                    title: .localized(UserString.Favorites),
                    emptyMessage: AttributedStringAsset.emptyFavoritesMessage)
    }
    
    fileprivate func makeWatchlist() -> UICollectionViewDataSource {
        makeSection(models: user.watchlist,
                    title: .localized(UserString.Watchlist),
                    emptyMessage: AttributedStringAsset.emptyWatchlistMessage)
    }
    
    fileprivate func makeRated() -> UICollectionViewDataSource {
        makeSection(models: user.rated,
                    title: .localized(UserString.Rated),
                    emptyMessage: AttributedStringAsset.emptyRatedMessage)
    }
    
    //MARK: Helper
    fileprivate func makeSection(models: [MovieViewModel], title: String, emptyMessage: NSAttributedString) -> UICollectionViewDataSource {
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
    
}
