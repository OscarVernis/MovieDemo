//
//  HomeLayoutProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

struct HomeLayoutProvider {
    private static let sectionBuilder = MoviesCompositionalLayoutBuilder.self
    
    static func createLayout(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let section = HomeDataSource.Section(rawValue: sectionIndex)
        
        switch(section) {
        case .nowPlaying:
            return makeBannerSection()
        case .upcoming:
            return makeHorizontalPosterSection()
        case .popular:
            return makeListSection()
        case .topRated:
            return makeDecoratedListSection()
        default:
            return nil
        }
    }
    
    private static func makeBannerSection() -> NSCollectionLayoutSection {
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        
        let section: NSCollectionLayoutSection
        section = sectionBuilder.createBannerSection()
        section.contentInsets.top = 10
        section.contentInsets.bottom = 10
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func makeHorizontalPosterSection() -> NSCollectionLayoutSection {
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        
        let section: NSCollectionLayoutSection
        section = sectionBuilder.createHorizontalPosterSection()
        section.contentInsets.top = 10
        section.contentInsets.bottom = 20
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func makeListSection() -> NSCollectionLayoutSection {
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        
        let section: NSCollectionLayoutSection
        section = sectionBuilder.createListSection()
        section.contentInsets.bottom = 30
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func makeDecoratedListSection() -> NSCollectionLayoutSection {
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        
        let section: NSCollectionLayoutSection
        section = sectionBuilder.createDecoratedListSection()
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
