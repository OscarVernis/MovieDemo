//
//  MovieDetailCrewSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailCrewSection: ConfigurableSection {
    var title = NSLocalizedString("Crew", comment: "")
    var topCrew: [CrewCreditViewModel]
    
    var titleHeaderButtonHandler: (()->Void)?
    
    init(crew: [CrewCreditViewModel], titleHeaderButtonHandler: (()->Void)? = nil) {
        self.topCrew = crew
        self.titleHeaderButtonHandler = titleHeaderButtonHandler
    }
    
    var itemCount: Int {
        return topCrew.count
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        InfoListCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createListSection(height: 50, columns: 2)

        section.contentInsets.top = 5
        section.contentInsets.bottom = 10

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoListCell.reuseIdentifier, for: indexPath) as! InfoListCell

        let crew = topCrew[indexPath.row]
        CrewCreditInfoListCellConfigurator().configure(cell: cell, with: crew)

        return cell
    }
    
    
}
