//
//  UserProfileLayoutProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

struct UserProfileLayoutProvider {
    fileprivate let sectionBuilder = MoviesCompositionalLayoutBuilder()
    let user: UserViewModel

    func createLayout(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let section = UserProfileDataSource.Section(rawValue: sectionIndex)!
        
        switch section {
        case .header:
            return makeHeaderSection()
        case .favorites:
            return (user.favorites.count > 0) ? makeMoviesSection() : makeEmptySection()
        case .watchlist:
            return (user.watchlist.count > 0) ? makeMoviesSection() : makeEmptySection()
        case .rated:
            return (user.rated.count > 0) ? makeMoviesSection() : makeEmptySection()
        }
    }
    
    fileprivate func makeHeaderSection() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createSection(groupHeight: .estimated(150))
        
        let sectionHeader = sectionBuilder.createDetailSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    fileprivate func makeMoviesSection() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createHorizontalPosterSection()
        
        return makeTitleSection(with: section)
    }
    
    fileprivate func makeEmptySection() -> NSCollectionLayoutSection {
        let section = sectionBuilder.createSection(groupHeight: .estimated(260))
        section.contentInsets.top = 10
        section.contentInsets.bottom = 20
        
        return makeTitleSection(with: section)
    }
    
    fileprivate func makeTitleSection(with section: NSCollectionLayoutSection) -> NSCollectionLayoutSection {
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
