//
//  MovieDetailTrailerSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailTrailerSection: ConfigurableSection {
    var itemCount: Int {
        return 1
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        TrailerCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        let section = sectionBuilder.createListSection(height: 65)
        section.contentInsets.bottom = 0
        
        return section
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCell.reuseIdentifier, for: indexPath)
        
        return cell
    }
    
}
