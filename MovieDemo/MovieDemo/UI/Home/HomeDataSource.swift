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
    enum Section: Int {
        case nowPlaying, upcoming, popular, topRated
    }
    
    unowned var collectionView: UICollectionView

    var providers: [MoviesDataProvider] = []
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(dataSources: [])
        
        registerReusableViews()
        setupDataSources()
        refresh()
    }
    
    var didUpdate: ((Section, Error?) -> Void)?
    
    //MARK: - Setup
    func registerReusableViews() {
        MoviePosterInfoCell.register(to: collectionView)
        MovieBannerCell.register(to: collectionView)
        MovieRatingListCell.register(to: collectionView)
        MovieInfoListCell.register(to: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
    }
    
    func setupDataSources() {
        dataSources = [
            makeNowPlaying(),
            makeUpcoming(),
            makePopular(),
            makeTopRated()
        ]
        
        for (section, provider) in providers.enumerated() {
            provider.didUpdate = { [weak self] error in
                self?.didUpdate?(Section(rawValue: section)!, error)
                self?.collectionView.reloadData()
            }
        }

    }
    
    func refresh() {
        providers.forEach { $0.refresh() }
    }
        
    //MARK: - Data Sources
    func makeNowPlaying() -> UICollectionViewDataSource {
        let provider = MoviesDataProvider(.NowPlaying)
        providers.append(provider)
        
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: MovieBannerCell.reuseIdentifier,
                                            cellConfigurator: MovieBannerCell.configure)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.NowPlaying),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeUpcoming() -> UICollectionViewDataSource {
        let provider = MoviesDataProvider(.Upcoming)
        providers.append(provider)
        
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: MoviePosterInfoCell.reuseIdentifier,
                                            cellConfigurator: MoviePosterInfoCell.configureWithDate)
        

        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.Upcoming),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makePopular() -> UICollectionViewDataSource {
        let provider = MoviesDataProvider(.Popular)
        providers.append(provider)
        
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: MovieInfoListCell.reuseIdentifier, cellConfigurator: MovieInfoCellConfigurator().configure)
      
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.Popular),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeTopRated() -> UICollectionViewDataSource {
        let dataSource = TopRatedDataSource()
        providers.append(dataSource.dataProvider)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.TopRated),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    //MARK: - Header Data Source
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: 0)

        return dataSource.collectionView!(collectionView, viewForSupplementaryElementOfKind: kind, at:indexPath)
    }
    
}
