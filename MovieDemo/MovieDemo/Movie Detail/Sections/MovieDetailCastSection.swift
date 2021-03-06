//
//  MovieDetailCastSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailCastSection: ConfigurableSection {
    var title = NSLocalizedString("Cast", comment: "")
    var topCast: [CastCreditViewModel]
    
    var titleHeaderButtonHandler: (()->Void)?
    
    init(cast: [CastCreditViewModel]) {
        self.topCast = cast
    }
    
    var itemCount: Int {
        return topCast.count
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        CreditCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createHorizontalCreditSection()

        section.contentInsets.top = 8
        section.contentInsets.bottom = 0

        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
        
        MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: title, tapHandler: titleHeaderButtonHandler)
        
        return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditCell.reuseIdentifier, for: indexPath) as! CreditCell

        let cast = topCast[indexPath.row]
        CastCreditCellConfigurator().configure(cell: cell, with: cast)

        return cell
    }
    
}
