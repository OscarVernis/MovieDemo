//
//  MovieDetailVideoSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailVideoSection: ConfigurableSection {
    var title = NSLocalizedString("Videos", comment: "")
    var videos: [MovieVideoViewModel]
        
    init(videos: [MovieVideoViewModel]) {
        self.videos = videos
    }
    
    var itemCount: Int {
        return videos.count
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        YoutubeVideoCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createBannerSection()
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.top = 10
        section.contentInsets.bottom = 0
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
        
        MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: title)
        
        return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YoutubeVideoCell.reuseIdentifier, for: indexPath) as! YoutubeVideoCell

        let movieVideo = videos[indexPath.row]
        cell.configure(video: movieVideo)

        return cell
    }
    
}
