//
//  OverviewSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class OverviewSection: ConfigurableSection {
    var title: String?
    var overview: String
    
    init(title: String? = nil, overview: String) {
        self.title = title
        self.overview = overview
    }
    
    var itemCount: Int {
        return 1
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        OverviewCell.register(to: collectionView)
        SectionTitleView.registerHeader(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createEstimatedSection(height: 50)
        
        if title != nil {
            let sectionHeader = sectionBuilder.createTitleSectionHeader()
            sectionHeader.contentInsets.top = 6
            section.boundarySupplementaryItems = [sectionHeader]
        }
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
        
        MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: title!)
        
        return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.reuseIdentifier, for: indexPath) as! OverviewCell
        
        cell.textLabel.text = overview
        
        return cell
    }
    
}
