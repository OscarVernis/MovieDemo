//
//  UserProfileLayoutProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

struct UserProfileLayoutProvider {
    private static let sectionBuilder = MoviesCompositionalLayoutBuilder()
    
    static func layout(for section: UserProfileDataSource.Section, itemCount: Int) -> NSCollectionLayoutSection? {
        switch section {
        case .header:
            return makeHeaderSection()
        case .favorites, .watchlist, .rated:
            return (itemCount > 0) ? makeMoviesSection() : makeEmptySection()
        }
    }
    
    private static func makeHeaderSection() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createSection(groupHeight: .estimated(150))
        
        let sectionHeader = sectionBuilder.createDetailSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func makeMoviesSection(addBottomInset: Bool = false) -> NSCollectionLayoutSection {
        let section = sectionBuilder.createHorizontalPosterSection()
        
        return makeTitleSection(with: section)
    }
    
    private static func makeEmptySection() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createSection(groupHeight: .estimated(260))
        section.contentInsets.top = 10
        section.contentInsets.bottom = 20
        
        return makeTitleSection(with: section)
    }
    
    private static func makeTitleSection(with section: NSCollectionLayoutSection) -> NSCollectionLayoutSection {
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
