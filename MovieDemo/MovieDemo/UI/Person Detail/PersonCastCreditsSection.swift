//
//  PersonCastCreditsSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonCastCreditsSection: ConfigurableSection {
    let title: String
    let credits: [PersonCastCreditViewModel]
    
    init(title: String, credits: [PersonCastCreditViewModel]) {
        self.title = title
        self.credits = credits
    }
    
    var itemCount: Int {
        return credits.count
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        SectionTitleView.registerHeader(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createListSection(height: 50)
        
        section.contentInsets.top = 5
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCreditCell.reuseIdentifier, for: indexPath) as! PersonCreditCell

        let credit = credits[indexPath.row]
        PersonCreditConfigurator().configure(cell: cell, castCredit: credit)

        return cell
    }
    
    
}
