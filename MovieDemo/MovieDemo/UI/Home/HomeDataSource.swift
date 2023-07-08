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

    var providers: [MoviesProvider] = []
    var nowPlayingProvider: MoviesProvider
    var upcomingProvider: MoviesProvider
    var popularProvider: MoviesProvider
    var topRatedProvider: MoviesProvider
    
    init(collectionView: UICollectionView,
         nowPlayingProvider: MoviesProvider,
         upcomingProvider: MoviesProvider,
         popularProvider: MoviesProvider,
         topRatedProvider: MoviesProvider) {
        self.collectionView = collectionView
        self.nowPlayingProvider = nowPlayingProvider
        self.upcomingProvider = upcomingProvider
        self.popularProvider = popularProvider
        self.topRatedProvider = topRatedProvider
        super.init()
        
        registerReusableViews()
        setupDataSources()
        refresh()
    }
    
    var didUpdate: ((Section, Error?) -> Void)?
    
    //MARK: - Setup
    func registerReusableViews() {
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
        MovieBannerCell.register(to: collectionView)
        MovieRatingListCell.register(to: collectionView)
        MovieInfoListCell.register(to: collectionView)
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
        makeSection(provider: nowPlayingProvider,
                    title: .localized(HomeString.NowPlaying),
                    reuseIdentifier: MovieBannerCell.reuseIdentifier,
                    cellConfigurator: MovieBannerCell.configure)
    }
    
    func makeUpcoming() -> UICollectionViewDataSource {
        makeSection(provider: upcomingProvider,
                    title: .localized(HomeString.Upcoming),
                    reuseIdentifier: MoviePosterInfoCell.reuseIdentifier,
                    cellConfigurator: MoviePosterInfoCell.configureWithDate)
    }
    
    func makePopular() -> UICollectionViewDataSource {
        makeSection(provider: popularProvider,
                    title: .localized(HomeString.Popular),
                    reuseIdentifier: MovieInfoListCell.reuseIdentifier,
                    cellConfigurator: MovieInfoListCell.configure)
    }
    
    func makeTopRated() -> UICollectionViewDataSource {
        let dataSource = TopRatedDataSource(provider: topRatedProvider)
        providers.append(topRatedProvider)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(HomeString.TopRated),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    //MARK: Helper
    func makeSection<Cell: UICollectionViewCell>(provider: MoviesProvider, title: String, reuseIdentifier: String, cellConfigurator: @escaping (Cell, MovieViewModel) -> Void) -> UICollectionViewDataSource {
        
        providers.append(provider)
        
        let dataSource = ProviderDataSource(dataProvider: provider,
                                            reuseIdentifier: reuseIdentifier,
                                            cellConfigurator: cellConfigurator)
        
        let titleDataSource = TitleHeaderDataSource(title: title,
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
