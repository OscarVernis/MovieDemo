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

class HomeDataSource: SectionedCollectionDataSource {
    unowned var collectionView: UICollectionView

    var providers: [MoviesDataProvider] = []
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(dataSources: [])
        
        registerReusableViews()
        setupDataSources()
        refresh()
    }
    
    typealias Section = Int
    var didUpdate: ((Section, Error?) -> Void)?
    
    //MARK: - Setup
    func registerReusableViews() {
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
                self?.collectionView.reloadData()
            }
        }

    }
    
    func makeNowPlaying() -> UICollectionViewDataSource {
        let provider = MoviesDataProvider(.NowPlaying)
        providers.append(provider)
        
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: MovieBannerCell.reuseIdentifier) { movie, cell, _ in
            guard let cell = cell as? MovieBannerCell else { return }
                    
            MovieBannerCellConfigurator().configure(cell: cell, with: movie)
        }
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.NowPlaying),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeUpcoming() -> UICollectionViewDataSource {
        let provider = MoviesDataProvider(.Upcoming)
        providers.append(provider)
        
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: MoviePosterInfoCell.reuseIdentifier) { movie, cell, _ in
            guard let cell = cell as? MoviePosterInfoCell else { return }
                    
            MoviePosterTitleDateCellConfigurator().configure(cell: cell, with: movie)
        }

        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.Upcoming),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makePopular() -> UICollectionViewDataSource {
        let provider = MoviesDataProvider(.Popular)
        providers.append(provider)
        
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: MovieInfoListCell.reuseIdentifier) { movie, cell, _ in
            guard let cell = cell as? MovieInfoListCell else { return }
                    
            MovieInfoCellConfigurator().configure(cell: cell, with: movie)
        }
      
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.Popular),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeTopRated() -> UICollectionViewDataSource {
        let provider = MoviesDataProvider(.TopRated)
        providers.append(provider)
        
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: MovieRatingListCell.reuseIdentifier) { movie, cell, indexPath in
            guard let cell = cell as? MovieRatingListCell else { return }
                    
            MovieRatingListCellConfigurator().configure(cell: cell, withMovie: movie, showSeparator: true)
        }
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.TopRated),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: 0)

        return dataSource.collectionView!(collectionView, viewForSupplementaryElementOfKind: kind, at:indexPath)
    }
    
}
