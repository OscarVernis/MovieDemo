//
//  MoviesCompositionalLayoutBuilder.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
 
struct MoviesCompositionalLayoutBuilder {
    var spacing: CGFloat = 20
    
    init() {
        if let screenWidth = UIApplication.shared.windows.first(where: \.isKeyWindow)?.bounds.width, screenWidth > 500 {
            spacing = 50
        }
    }
    
    //MARK:- General
    func createHeader(height: NSCollectionLayoutDimension) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: height)
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        return sectionHeader
    }
    
    func createSection(itemWidth: NSCollectionLayoutDimension = .fractionalWidth(1.0),
                       itemHeight: NSCollectionLayoutDimension = .fractionalHeight(1.0),
                       groupWidth: NSCollectionLayoutDimension = .fractionalWidth(1.0),
                       groupHeight: NSCollectionLayoutDimension = .fractionalHeight(1.0),
                       columns: Int = 1
    ) ->  NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
                        
        return section
    }
    
    //MARK:- Headers
    func createTitleSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return createHeader(height: .absolute(48))
    }
    
    //The Header section for MovieDetailViewController
    func createMovieDetailSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return createHeader(height: .estimated(500))
    }
    
    //MARK:- Lists
    
    //Regular List
    func createListSection(height: CGFloat = 150, columns: Int = 1) ->  NSCollectionLayoutSection {
        let section = createSection(groupHeight: .absolute(height))
                        
        return section
    }
    
    //List with background decorator
    func createDecoratedListSection(height: CGFloat = 50) ->  NSCollectionLayoutSection {
        let section = createListSection(height: height)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: spacing, bottom: 20, trailing: spacing)
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundDecorationView.elementKind)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 15, trailing: spacing)
        section.decorationItems = [sectionBackgroundDecoration]
                
        return section
    }
    
    //MARK:- Other
    
    //Horizontal scroll with no paging, several items at a time
    func createHorizontalPosterSection() ->  NSCollectionLayoutSection {
        let section = createSection(groupWidth: .estimated(140), groupHeight: .absolute(260))

        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        
        return section
    }
    
    //Similar to Poster section with a different size
    func createHorizontalCreditSection() ->  NSCollectionLayoutSection {
        let section = createSection(groupWidth: .absolute(115), groupHeight: .estimated(220))

        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20

        return section
    }
    
    //Section with items that are screen wide, usually for showing just one item
    func createEstimatedSection(height: CGFloat = 1.0) ->  NSCollectionLayoutSection {
        let section = createSection(itemHeight: .estimated(height), groupHeight: .estimated(height))
                                
        return section
    }
    
    //Horizontal scroll, shows only one complete item and a peek at the next
    func createBannerSection() ->  NSCollectionLayoutSection {
        let section = createSection(itemHeight: .estimated(1.0), groupWidth: .fractionalWidth(0.85), groupHeight: .estimated(500))
        
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 20
                        
        return section
    }
    
}
