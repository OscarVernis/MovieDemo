//
//  GenericCollection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

protocol GenericCollection: UIViewController, UICollectionViewDelegate {
    var collectionView: UICollectionView! { get set }
    var dataSource: GenericCollectionDataSource! { get set }
    
    func createLayout() -> UICollectionViewLayout
}

extension GenericCollection {
    func createCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let section = self.dataSource.sections[sectionIndex]
            return section.sectionLayout()
        }
        
        return layout
    }
    
}
