//
//  MovieDetailDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailDataSource: SectionedCollectionDataSource {
    enum Section: Int, CaseIterable {
        case header
        case cast
        case crew
        case videos
        case recommended
        case info
    }
    
    unowned var collectionView: UICollectionView
    let movie: MovieViewModel
    
    var sections: [Section] = []
    
    init(collectionView: UICollectionView, movie: MovieViewModel) {
        self.collectionView = collectionView
        self.movie = movie
        
        super.init()
        
        registerReusableViews()
        setupSections()
    }
    
    func reload() {
        setupSections()
    }
    
    //MARK: - Setup
    func registerReusableViews() {
        MovieDetailHeaderView.registerHeader(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(to: collectionView)
        CreditCell.register(to: collectionView)
        InfoListCell.register(to: collectionView)
        YoutubeVideoCell.register(to: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
    }
    
    func setupSections() {
        sections = [
            .header,
            .cast,
            .crew,
            .videos,
            .recommended,
            .info
        ]
        
        dataSources = sections.compactMap(dataSource(for:))
    }
    
    func dataSource(for section: Section) -> UICollectionViewDataSource? {
        switch section {
        case .header:
            return makeMovieHeader()
        case .cast:
            if !movie.topCast.isEmpty { return makeCast() }
        case .crew:
            if !movie.topCrew.isEmpty { return makeCrew() }
        case .videos:
            if !movie.videos.isEmpty { return makeVideos() }
        case .recommended:
            if !movie.recommendedMovies.isEmpty { return makeRecommended() }
        case .info:
            if !movie.infoArray.isEmpty && !movie.isLoading { return makeInfo() }
        }
        
        return nil
    }
    
    //MARK: - Data Sources
    func makeMovieHeader() -> UICollectionViewDataSource {
        return MovieHeaderDataSource(movie: movie)
    }
    
    func makeTitleHeader(title: String, dataSource: UICollectionViewDataSource) -> UICollectionViewDataSource {
        let titleDataSource = TitleHeaderDataSource(title: title,
                                                    dataSource: dataSource,
                                                    headerConfigurator: SectionTitleView.configureForDetail)
        
        return titleDataSource
    }
    
    func makeCast() -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: movie.topCast,
                                                   reuseIdentifier: CreditCell.reuseIdentifier,
                                                   cellConfigurator: CreditCell.configure)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(MovieString.Cast),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeCrew() -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: movie.topCrew,
                                                   reuseIdentifier: InfoListCell.reuseIdentifier,
                                                   cellConfigurator: InfoListCell.configure)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(MovieString.Crew),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeVideos() -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: movie.videos,
                                                   reuseIdentifier: YoutubeVideoCell.reuseIdentifier,
                                                   cellConfigurator: YoutubeVideoCell.configure)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(MovieString.Videos),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeRecommended() -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: movie.recommendedMovies,
                                                   reuseIdentifier: MoviePosterInfoCell.reuseIdentifier,
                                                   cellConfigurator: MoviePosterInfoCell.configureWithRating)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(MovieString.RecommendedMovies),
                                                          dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeInfo() -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: movie.infoArray,
                                                   reuseIdentifier: InfoListCell.reuseIdentifier,
                                                   cellConfigurator: InfoListCell.configure)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(MovieString.Info),
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
