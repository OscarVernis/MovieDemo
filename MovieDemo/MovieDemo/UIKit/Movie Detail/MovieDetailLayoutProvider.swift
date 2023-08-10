//
//  MovieDetailLayoutProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 13/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieDetailLayoutProvider {
    private static var sectionBuilder = CompositionalLayoutBuilder.self
    
    static func layout(for section: MovieDetailDataSource.Section) -> NSCollectionLayoutSection? {
        switch section {
        case .loading:
            return makeLoading()
        case .cast:
            return makeCast()
        case .crew:
            return makeCrew()
        case .videos:
            return makeVideos()
        case .recommended:
            return makeRecommended()
        case .info:
            return makeInfo()
        }
    }

    private static func makeLoading() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 100, margin: 0)
        
        return section
    }
    
    private static func makeCast() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createHorizontalCreditSection()

        section.contentInsets.top = 8
        section.contentInsets.bottom = 0

        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func makeCrew() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 50, columns: 2)

        section.contentInsets.top = 5
        section.contentInsets.bottom = 10

        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func makeRecommended() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createHorizontalPosterSection()
        
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func makeVideos() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createVideoBannerSection()
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.top = 10
        section.contentInsets.bottom = 0
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func makeInfo() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 52)
        
        section.contentInsets.top = 0
        section.contentInsets.bottom = 0
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
