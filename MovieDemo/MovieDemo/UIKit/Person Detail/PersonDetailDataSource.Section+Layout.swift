//
//  PersonDetailDataSource.Section+Layout.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 13/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

extension PersonDetailDataSource.Section {
    func sectionLayout() -> NSCollectionLayoutSection {
        switch self {
        case .overview:
            return makeOverview()
        case .popular:
            return makePopular()
        case .castCredits, .crewCredits:
            return makeCredits()
        }
        
    }
    
    fileprivate func makeOverview() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
        return sectionBuilder.createEstimatedSection(height: 50)
    }
    
    fileprivate func makePopular() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createHorizontalPosterSection()
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate func makeCredits() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createListSection(height: 100)
        
        section.contentInsets.top = 5
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
