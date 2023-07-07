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
    var movie: MovieViewModel
    var isLoading: Bool
    
    var sections: [Section] = []
    
    init(collectionView: UICollectionView, movie: MovieViewModel, isLoading: Bool) {
        self.collectionView = collectionView
        self.movie = movie
        self.isLoading = isLoading
        
        super.init()
        
        registerReusableViews()
        setupSections()
    }
    
    func reload() {
        setupSections()
    }
    
    //MARK: - Setup
    fileprivate func registerReusableViews() {
        MovieDetailHeaderView.registerHeader(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(to: collectionView)
        CreditCell.register(to: collectionView)
        InfoListCell.register(to: collectionView)
        YoutubeVideoCell.register(to: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
    }
    
    fileprivate func setupSections() {
        sections = [
            .header,
            .cast,
            .crew,
            .videos,
            .recommended,
            .info
        ]
                
        sections = sections.filter(validate(section:))
        dataSources = sections.map(dataSource(for:))
    }
    
    fileprivate func validate(section: Section) -> Bool {
        switch section {
        case .header:
            return true
        case .cast:
            if !movie.topCast.isEmpty { return true }
        case .crew:
            if !movie.topCrew.isEmpty { return true }
        case .videos:
            if !movie.videos.isEmpty { return true }
        case .recommended:
            if !movie.recommendedMovies.isEmpty { return true }
        case .info:
            if !movie.infoArray.isEmpty && !isLoading { return true }
        }
        
        return false
    }
    
    fileprivate func dataSource(for section: Section) -> UICollectionViewDataSource {
        switch section {
        case .header:
            return makeMovieHeader()
        case .cast:
            return makeCast()
        case .crew:
            return makeCrew()
        case .videos:
            return makeVideos()
        case .recommended:
            return makeRecommended()
        case .info:
            return makeInfo()
        }
    }
    
    //MARK: - Data Sources
    fileprivate func makeMovieHeader() -> UICollectionViewDataSource {
        return MovieHeaderDataSource(movie: movie, isLoading: isLoading)
    }
    
    fileprivate func makeCast() -> UICollectionViewDataSource {
        makeSection(models: movie.topCast,
                    title: .localized(MovieString.Cast),
                    reuseIdentifier: CreditCell.reuseIdentifier,
                    cellConfigurator: CreditCell.configure)
    }
    
    fileprivate func makeCrew() -> UICollectionViewDataSource {
        makeSection(models: movie.topCrew,
                    title: .localized(MovieString.Crew),
                    reuseIdentifier: InfoListCell.reuseIdentifier,
                    cellConfigurator: InfoListCell.configure)
    }
    
    fileprivate func makeVideos() -> UICollectionViewDataSource {
        makeSection(models: movie.videos,
                    title: .localized(MovieString.Videos),
                    reuseIdentifier: YoutubeVideoCell.reuseIdentifier,
                    cellConfigurator: YoutubeVideoCell.configure)
    }
    
    fileprivate func makeRecommended() -> UICollectionViewDataSource {
        makeSection(models: movie.recommendedMovies,
                    title: .localized(MovieString.RecommendedMovies),
                    reuseIdentifier: MoviePosterInfoCell.reuseIdentifier,
                    cellConfigurator: MoviePosterInfoCell.configureWithRating)
    }
    
    fileprivate func makeInfo() -> UICollectionViewDataSource {
        makeSection(models: movie.infoArray,
                    title: .localized(MovieString.Info),
                    reuseIdentifier: InfoListCell.reuseIdentifier,
                    cellConfigurator: InfoListCell.configure)
    }
    
    //MARK: Helper
    fileprivate func makeSection<Model, Cell: UICollectionViewCell>(models: [Model], title: String, reuseIdentifier: String, cellConfigurator: @escaping (Cell, Model) -> Void) -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: models,
                                                   reuseIdentifier: reuseIdentifier,
                                                   cellConfigurator: cellConfigurator)
        
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
