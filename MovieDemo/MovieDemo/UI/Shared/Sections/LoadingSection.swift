//
//  LoadingSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class LoadingSection: ConfigurableSection {    
    var isLoading = true
        
    var itemCount: Int {
        return isLoading ? 1 : 0
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        LoadingCell.register(to: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        return sectionBuilder.createListSection(height: 100)
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
    }
    
}
