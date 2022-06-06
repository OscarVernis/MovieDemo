//
//  HomeMovieListSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class HomeMovieListSection: FetchableSection {
    enum SectionType: Int, CaseIterable {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
        
        func title() -> String {
            switch self {
            case .NowPlaying:
                return .localized(HomeString.NowPlaying)
            case .Popular:
                return .localized(HomeString.Popular)
            case .TopRated:
                return .localized(HomeString.TopRated)
            case .Upcoming:
                return .localized(HomeString.Upcoming)
            }
        }
    }
    
    var title: String {
        sectionType.title()
    }
    
    var dataProvider: MoviesDataProvider
    var movieService: MovieList = .NowPlaying
    
    var sectionType: SectionType = .NowPlaying
    
    var didUpdate: ((Error?) -> Void)?
    
    let maxTopRated = 10
    
    var sectionHeaderButtonHandler: ((HomeMovieListSection) -> Void)?
                
    init(_ section: SectionType, sectionHeaderButtonHandler: ((HomeMovieListSection) -> Void)?) {
        self.sectionType = section
        self.sectionHeaderButtonHandler = sectionHeaderButtonHandler
        
        switch sectionType {
        case .NowPlaying:
            self.dataProvider = MoviesDataProvider(.NowPlaying)
        case .Popular:
            self.dataProvider = MoviesDataProvider(.Popular)
        case .TopRated:
            self.dataProvider = MoviesDataProvider(.TopRated)
        case .Upcoming:
            self.dataProvider = MoviesDataProvider(.Upcoming)
        }
        
        self.dataProvider.didUpdate = { [weak self] error in
            self?.didUpdate?(error)
        }
    }
    
    var itemCount: Int {
        if sectionType == .TopRated, dataProvider.itemCount >= maxTopRated {
            return maxTopRated
        } else {
            return dataProvider.itemCount
        }

    }
    
    var isLastPage: Bool {
        return dataProvider.isLastPage
    }
    
    func loadMore() {
        dataProvider.loadMore()
    }
    
    func refresh() {
        dataProvider.refresh()
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        MoviePosterInfoCell.register(withCollectionView: collectionView)
        MovieBannerCell.register(withCollectionView: collectionView)
        MovieRatingListCell.register(withCollectionView: collectionView)
        MovieInfoListCell.register(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        switch sectionType {
        case .NowPlaying:
            section = sectionBuilder.createBannerSection()
            section.contentInsets.top = 10
            section.contentInsets.bottom = 10
        case .Upcoming:
            section = sectionBuilder.createHorizontalPosterSection()
            section.contentInsets.top = 10
            section.contentInsets.bottom = 20
        case .Popular:
            section = sectionBuilder.createListSection()
            section.contentInsets.bottom = 30
        case .TopRated:
            section = sectionBuilder.createDecoratedListSection()
            sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        }
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as? SectionTitleView  else { fatalError() }
        
        let tapHandler: (() -> ())? = { [weak self] in
            guard let self = self else { return }
            
            self.sectionHeaderButtonHandler?(self)
        }
        
        HomeTitleSectionConfigurator().configure(headerView: sectionTitleView, title: sectionType.title(), tapHandler: tapHandler)
        
        return sectionTitleView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let movie = dataProvider.item(atIndex: indexPath.row)
        
        var cell: UICollectionViewCell
        switch sectionType {
        case .NowPlaying:
            let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieBannerCell.reuseIdentifier, for: indexPath) as! MovieBannerCell
            
            MovieBannerCellConfigurator().configure(cell: bannerCell, withMovie: movie)
            cell = bannerCell
        case .Upcoming:
            let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
            
            MoviePosterTitleDateCellConfigurator().configure(cell: posterCell, with: movie)
            cell = posterCell
        case .TopRated:
            let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieRatingListCell.reuseIdentifier, for: indexPath) as! MovieRatingListCell
            
            let topRatedCount = maxTopRated <= dataProvider.itemCount ? maxTopRated : dataProvider.itemCount
            let isLastCell = indexPath.row == (topRatedCount - 1) //dataProvider.movies.count - 1
            MovieRatingListCellConfigurator().configure(cell: listCell, withMovie: movie, showSeparator: !isLastCell)
            cell = listCell
        case .Popular:
            let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoListCell.reuseIdentifier, for: indexPath) as! MovieInfoListCell
            
            MovieInfoCellConfigurator().configure(cell: infoCell, with: movie)
            cell = infoCell
        }
        
        return cell
    }
    
}
