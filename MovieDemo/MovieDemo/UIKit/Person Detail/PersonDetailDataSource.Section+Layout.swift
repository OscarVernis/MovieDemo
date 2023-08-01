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
        case .creditCategories:
            return makeCreditCategories()
        case .castCredits, .crewCredits:
            return makeCredits()
        case .info:
            return makeInfo()
        }
        
    }
    
    fileprivate func makeOverview() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
        let section = sectionBuilder.createEstimatedSection(height: 50)
        section.contentInsets.top = 6
        
        return section
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
        let section = sectionBuilder.createListSection(height: 121)
        
        section.contentInsets.top = 5
        section.contentInsets.bottom = 0
        
        return section
    }
    
    fileprivate func makeCreditCategories() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createHorizontalCategorySection()
        
        section.contentInsets.top = 4
        section.contentInsets.bottom = 4
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate func makeInfo() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section: NSCollectionLayoutSection
        
        section = sectionBuilder.createDecoratedListSection(height: 52, topSpacing: 16)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 36, bottom: 24, trailing: 36)

        return section
    }
    
}
