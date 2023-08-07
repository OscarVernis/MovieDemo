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
    
    var loadingCellId = UUID().uuidString
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
            return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
        case .cast:
            let model = movie.topCast[indexPath.row]
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: CreditCell.configure)
        case .crew:
            let model = movie.topCrew[indexPath.row]
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: InfoListCell.configure)
        case .videos:
            let model = movie.videos[indexPath.row]
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: YoutubeVideoCell.configure)
        case .recommended:
            let model = movie.recommendedMovies[indexPath.row]
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: MoviePosterInfoCell.configureWithDate)
        case .info:
            return infoCell(at: indexPath, with: collectionView, identifier: identifier)
        }
        
    }
    
    private func infoCell(at indexPath: IndexPath, with collectionView: UICollectionView, identifier: AnyHashable) -> UICollectionViewCell {
        if identifier as? String == socialItemId {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialCell.reuseIdentifier, for: indexPath) as! SocialCell
            cell.socialLinks = movie.socialLinks
            cell.didSelect = openSocialLink
            return cell
        } else {
            let model = identifier as! [String : String]
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: InfoListCell.configure)
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
                    snapshot.appendItems([loadingCellId], toSection: .header)
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
        
        applySnapshotUsingReloadData(snapshot)
    }
    
    //MARK: - Headers
    func sectionTitle(for section: Section) -> String {
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
