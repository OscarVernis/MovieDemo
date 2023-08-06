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
        switch section {
        case .nowPlaying:
            return nowPlayingCell(at: indexPath, model: identifier as! HomeSectionMovie, with: collectionView)
        case .upcoming:
            return upcomingCell(at: indexPath, model: identifier as! HomeSectionMovie, with: collectionView)
        case .popular:
            return popularCell(at: indexPath, model: identifier as! HomeSectionMovie, with: collectionView)
        case .topRated:
            return topRatedCell(at: indexPath, model: identifier as! HomeSectionMovie, with: collectionView)
        }
    }
    
    private func nowPlayingCell(at indexPath: IndexPath, model: HomeSectionMovie, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieBannerCell.reuseIdentifier, for: indexPath) as! MovieBannerCell
        let movie = model.movie
        MovieBannerCell.configure(cell: cell, with: movie)
        return cell
    }
    
    private func upcomingCell(at indexPath: IndexPath, model: HomeSectionMovie, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
        let movie = model.movie
        MoviePosterInfoCell.configureWithDate(cell: cell, with: movie)
        return cell
    }
    
    private func popularCell(at indexPath: IndexPath, model: HomeSectionMovie, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoListCell.reuseIdentifier, for: indexPath) as! MovieInfoListCell
        let movie = model.movie
        MovieInfoListCell.configure(cell: cell, with: movie)
        return cell
    }
    
    private func topRatedCell(at indexPath: IndexPath, model: HomeSectionMovie, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieRatingListCell.reuseIdentifier, for: indexPath) as! MovieRatingListCell
        let movie = model.movie
        MovieRatingListCell.configure(cell: cell, withMovie: movie)
        
        //Hide last separator
        cell.separator.isHidden = (indexPath.row == maxTopRated - 1)
        
        return cell
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
