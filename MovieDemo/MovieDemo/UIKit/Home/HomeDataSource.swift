//
//  HomeDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

struct HomeSectionMovie: Hashable {
    let section: HomeDataSource.Section
    let movie: MovieViewModel
}

class HomeDataSource: UICollectionViewDiffableDataSource<HomeDataSource.Section, HomeSectionMovie> {
    enum Section: Int, CaseIterable {
        case nowPlaying, upcoming, popular, topRated
    }

    var maxTopRated = 10
    
    //MARK: - Cell Setup
    func registerReusableViews(collectionView: UICollectionView) {
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
        MovieBannerCell.register(to: collectionView)
        MovieRatingListCell.register(to: collectionView)
        MovieInfoListCell.register(to: collectionView)
    }
    
    func cell(for collectionView: UICollectionView, with indexPath: IndexPath, identifier: AnyHashable) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        let model = (identifier as! HomeSectionMovie).movie
        switch section {
        case .nowPlaying:
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: MovieBannerCell.configure)
        case .upcoming:
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: MoviePosterInfoCell.configureWithDate)
        case .popular:
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: MovieInfoListCell.configure)
        case .topRated:
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: { [unowned self] (cell: MovieRatingListCell, movie) in
                MovieRatingListCell.configure(cell: cell, withMovie: movie)
                
                //Hide last separator
                cell.separator.isHidden = (indexPath.row == self.maxTopRated - 1)
            })
        }
    }
    
    //MARK: - Header Data Source
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as? SectionTitleView  else { fatalError() }
            
            let section = Section(rawValue: indexPath.section)!
            SectionTitleView.configureForHome(headerView: sectionTitleView, title: sectionTitle(for: section))
            
            return sectionTitleView
    }
    
    private func sectionTitle(for section: Section) -> String {
        switch section {
        case .nowPlaying:
            return .localized(HomeString.NowPlaying)
        case .upcoming:
            return .localized(HomeString.Upcoming)
        case .popular:
            return .localized(HomeString.Popular)
        case .topRated:
            return .localized(HomeString.TopRated)
        }
    }
    
}
