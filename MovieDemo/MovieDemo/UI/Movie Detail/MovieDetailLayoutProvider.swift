//
//  MovieDetailLayoutProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieDetailLayoutProvider {
    let sectionBuilder = MoviesCompositionalLayoutBuilder()
    
    func createLayout(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let section = MovieDetailDataSource.Section(rawValue: sectionIndex)!
        switch section {
        case .header:
            return makeHeader()
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
    
    func makeHeader() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 100)

        let sectionHeader = sectionBuilder.createDetailSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeCast() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createHorizontalCreditSection()

        section.contentInsets.top = 8
        section.contentInsets.bottom = 0

        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeCrew() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 50, columns: 2)

        section.contentInsets.top = 5
        section.contentInsets.bottom = 10

        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeRecommended() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createHorizontalPosterSection()
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeVideos() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createBannerSection()
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.top = 10
        section.contentInsets.bottom = 0
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func makeInfo() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 50)
        
        section.contentInsets.top = 5
        section.contentInsets.bottom = UIWindow.bottomInset + 30
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
