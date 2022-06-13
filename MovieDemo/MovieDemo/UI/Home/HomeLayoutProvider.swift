//
//  HomeLayoutProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

struct HomeLayoutProvider {
    let sectionBuilder = MoviesCompositionalLayoutBuilder()

    func createLayout(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
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
    
    
    func makeBannerSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        section = sectionBuilder.createBannerSection()
        section.contentInsets.top = 10
        section.contentInsets.bottom = 10
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeHorizontalPosterSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        section = sectionBuilder.createHorizontalPosterSection()
        section.contentInsets.top = 10
        section.contentInsets.bottom = 20
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeListSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        section = sectionBuilder.createListSection()
        section.contentInsets.bottom = 30
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }

    func makeDecoratedListSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let sectionHeader = sectionBuilder.createTitleSectionHeader()

        let section: NSCollectionLayoutSection
        section = sectionBuilder.createDecoratedListSection()
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}