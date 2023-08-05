//
//  MovieDetailDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 04/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailDataSource: UICollectionViewDiffableDataSource<MovieDetailDataSource.Section, AnyHashable> {
    enum Section: Int, CaseIterable {
        case header
        case cast
        case crew
        case videos
        case recommended
        case info
    }
    
    var movie: MovieViewModel!
    var isLoading: Bool = false
    
    var socialItemId = UUID().uuidString
    var openSocialLink: ((SocialLink) -> ())?
    
    var sections: [Section] = []
    
    //MARK: - Cell Setup
    func registerReusableViews(collectionView: UICollectionView) {
        MovieDetailHeaderView.registerHeader(withCollectionView: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        LoadingCell.register(to: collectionView)
        CreditCell.register(to: collectionView)
        InfoListCell.register(to: collectionView)
        YoutubeVideoCell.register(to: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
        SocialCell.register(to: collectionView)
    }
    
    func cell(for collectionView: UICollectionView, with indexPath: IndexPath, identifier: AnyHashable) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .header:
            return loadingCell(at: indexPath, with: collectionView)
        case .cast:
           return castCell(at: indexPath, with: collectionView)
        case .crew:
           return crewCell(at: indexPath, with: collectionView)
        case .videos:
           return videoCell(at: indexPath, with: collectionView)
        case .recommended:
          return recommendedCell(at: indexPath, with: collectionView)
        case .info:
            return infoCell(at: indexPath, with: collectionView, identifier: identifier)
        }
        
    }
    
    private func loadingCell(at indexPath: IndexPath, with collectionView: UICollectionView) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
    }
    
    private func castCell(at indexPath: IndexPath, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as! CreditCell
        let model = movie.topCast[indexPath.row]
        CreditCell.configure(cell: cell, with: model)
        return cell
    }
    
    private func crewCell(at indexPath: IndexPath, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoListCell.reuseIdentifier, for: indexPath) as! InfoListCell
        let model = movie.topCrew[indexPath.row]
        InfoListCell.configure(cell: cell, with: model)
        return cell
    }
    
    private func videoCell(at indexPath: IndexPath, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YoutubeVideoCell.reuseIdentifier, for: indexPath) as! YoutubeVideoCell
        let model = movie.videos[indexPath.row]
        YoutubeVideoCell.configure(cell: cell, video: model)
        return cell
    }
    
    private func recommendedCell(at indexPath: IndexPath, with collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
        let model = movie.recommendedMovies[indexPath.row]
        MoviePosterInfoCell.configureWithDate(cell: cell, with: model)
        return cell
    }
    
    private func infoCell(at indexPath: IndexPath, with collectionView: UICollectionView, identifier: AnyHashable) -> UICollectionViewCell {
        if identifier as? String == socialItemId {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialCell.reuseIdentifier, for: indexPath) as! SocialCell
            cell.socialLinks = movie.socialLinks
            cell.didSelect = openSocialLink
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoListCell.reuseIdentifier, for: indexPath) as! InfoListCell
            let model = identifier as! [String : String]
            InfoListCell.configure(cell: cell, info: model)
            return cell
        }
    }
    
    //MARK: - Reload    
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
    
    func reload(animated: Bool = true) {
        setupSections()
        
        var snapshot = NSDiffableDataSourceSnapshot<MovieDetailDataSource.Section, AnyHashable>()
        snapshot.appendSections(sections)
        
        for section in sections {
            switch section {
            case .header:
                if isLoading {
                    snapshot.appendItems([UUID().uuidString], toSection: .header)
                }
            case .cast:
                snapshot.appendItems(movie.topCast, toSection: .cast)
            case .crew:
                snapshot.appendItems(movie.topCrew, toSection: .crew)
            case .videos:
                snapshot.appendItems(movie.videos, toSection: .videos)
            case .recommended:
                snapshot.appendItems(movie.recommendedMovies, toSection: .recommended)
            case .info:
                if !movie.socialLinks.isEmpty {
                    snapshot.appendItems([socialItemId], toSection: .info)
                }
                snapshot.appendItems(movie.infoArray, toSection: .info)
            }
        }
        
        self.apply(snapshot, animatingDifferences: animated)

    }
    
    //MARK: - Headers
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        switch section {
        case .header:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
            headerView.configure(movie: movie)
            return headerView
        case .cast, .crew, .videos, .recommended, .info:
            let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
            SectionTitleView.configureForDetail(headerView: sectionTitleView, title: sectionTitle(for: section))
           return sectionTitleView
        }
    }
    
    private func sectionTitle(for section: Section) -> String {
        switch section {
        case .header:
            return ""
        case .cast:
            return .localized(MovieString.Cast)
        case .crew:
            return .localized(MovieString.Crew)
        case .videos:
            return .localized(MovieString.Videos)
        case .recommended:
            return .localized(MovieString.RecommendedMovies)
        case .info:
            return .localized(MovieString.Info)
        }
    }
    
}
