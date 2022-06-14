//
//  MovieDetailDataSource.Section+Layout.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 13/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

extension MovieDetailDataSource.Section {
    func sectionLayout() -> NSCollectionLayoutSection {
        switch self {
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
    
    fileprivate var sectionBuilder: MoviesCompositionalLayoutBuilder {
        MoviesCompositionalLayoutBuilder()
    }

    fileprivate func makeHeader() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 100)

        let sectionHeader = sectionBuilder.createDetailSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate func makeCast() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createHorizontalCreditSection()

        section.contentInsets.top = 8
        section.contentInsets.bottom = 0

        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate func makeCrew() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 50, columns: 2)

        section.contentInsets.top = 5
        section.contentInsets.bottom = 10

        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate func makeRecommended() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createHorizontalPosterSection()
        
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate func makeVideos() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createBannerSection()
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.top = 10
        section.contentInsets.bottom = 0
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate func makeInfo() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createListSection(height: 50)
        
        section.contentInsets.top = 5
        section.contentInsets.bottom = UIWindow.bottomInset + 30
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
