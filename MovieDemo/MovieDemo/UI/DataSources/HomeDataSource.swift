//
//  HomeDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class HomeDataSource: NSObject {
    unowned var collectionView: UICollectionView?
    var dataSources: [UICollectionViewDataSource]!
    
    var providers: [MoviesDataProvider] {
        let providerDataSources = dataSources as? [ProviderDataSource<MoviesDataProvider>] ?? []
        return providerDataSources.map(\.dataProvider)
    }
    
    override init() {
        super.init()
        
        registerReusableViews()
        setupDataSources()
        refresh()
    }
    
    typealias Section = Int
    var didUpdate: ((Section, Error?) -> Void)?
    
    //MARK: - Setup
    func registerReusableViews() {
        guard let collectionView = collectionView else { return }

        MoviePosterInfoCell.register(withCollectionView: collectionView)
        MovieBannerCell.register(withCollectionView: collectionView)
        MovieRatingListCell.register(withCollectionView: collectionView)
        MovieInfoListCell.register(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
    }
    
    func refresh() {
        providers.forEach { $0.refresh() }
    }
    
    //MARK: - Data Sources
    func setupDataSources() {
        dataSources = [
            makeNowPlaying(),
            makeUpcoming(),
            makePopular(),
            makeTopRated()
        ]
        
        for (section, provider) in providers.enumerated() {
            provider.didUpdate = { [weak self] error in
                self?.didUpdate?(section, error)
                self?.collectionView?.reloadSections(IndexSet(integer: section))
            }
        }

    }
    
    func makeNowPlaying() -> UICollectionViewDataSource {
        let dataSource = ProviderDataSource(dataProvider: MoviesDataProvider(.NowPlaying),
                                            reuseIdentifier: MovieBannerCell.reuseIdentifier) { movie, cell, _ in
            guard let cell = cell as? MovieBannerCell else { return }
                    
            MovieBannerCellConfigurator().configure(cell: cell, with: movie)
        }
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.NowPlaying),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeUpcoming() -> UICollectionViewDataSource {
        let dataSource = ProviderDataSource(dataProvider: MoviesDataProvider(.Upcoming),
                                            reuseIdentifier: MoviePosterInfoCell.reuseIdentifier) { movie, cell, _ in
            guard let cell = cell as? MoviePosterInfoCell else { return }
                    
            MoviePosterTitleDateCellConfigurator().configure(cell: cell, with: movie)
        }

        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.Upcoming),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makePopular() -> UICollectionViewDataSource {
        let dataSource = ProviderDataSource(dataProvider: MoviesDataProvider(.Popular),
                                            reuseIdentifier: MovieInfoListCell.reuseIdentifier) { movie, cell, _ in
            guard let cell = cell as? MovieInfoListCell else { return }
                    
            MovieInfoCellConfigurator().configure(cell: cell, with: movie)
        }
      
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.Popular),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeTopRated() -> UICollectionViewDataSource {
        let dataSource = ProviderDataSource(dataProvider: MoviesDataProvider(.TopRated),
                                            reuseIdentifier: MovieRatingListCell.reuseIdentifier) { movie, cell, indexPath in
            guard let cell = cell as? MovieRatingListCell else { return }
                    
            MovieRatingListCellConfigurator().configure(cell: cell, withMovie: movie, showSeparator: true)
        }
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.TopRated),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
}
