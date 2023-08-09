//
//  PersonDetailLayoutProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 13/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

struct PersonDetailLayoutProvider {
    private static var sectionBuilder = MoviesCompositionalLayoutBuilder()
    
    static func layout(for section: PersonDetailDataSource.Section) -> NSCollectionLayoutSection? {
        switch section {
        case .loading:
            return makeLoading()
        case .overview:
            return makeOverview()
        case .popular:
            return makePopular()
        case .departments:
            return makeCreditDepartments()
        case .castCredits, .crewCredits:
            return makeCredits()
        case .info:
            return makeInfo()
        }
    }
    
    fileprivate static func makeLoading() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createSection(itemHeight: .absolute(44), groupHeight: .absolute(44))
        section.contentInsets.top = 50
        
        return section
    }
    
    fileprivate static func makeOverview() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createEstimatedSection(height: 50)
        section.contentInsets.top = 6
        
        return section
    }
    
    fileprivate static func makePopular() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createHorizontalPosterSection()
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate static func makeCredits() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 121)
        
        section.contentInsets.top = 5
        section.contentInsets.bottom = 0
        
        return section
    }
    
    fileprivate static func makeCreditDepartments() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createSection(groupHeight: .absolute(32))
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        let margin = MoviesCompositionalLayoutBuilder.spacing
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: margin, bottom: 0, trailing: margin)
        
        return section
    }
    
    fileprivate static func makeInfo() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        
        section = sectionBuilder.createDecoratedListSection(height: 52, topSpacing: 20, bottomSpacing: 0, itemSpacing: 0)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 36, bottom: 8, trailing: 36)

        return section
    }
    
}
