//
//  ConfigurableSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

protocol ConfigurableSection {
    var itemCount: Int { get }
        
    func registerReusableViews(withCollectionView collectionView: UICollectionView)
    func sectionLayout() -> NSCollectionLayoutSection
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

extension ConfigurableSection {
    func reusableView(withCollectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        fatalError("Custom reusableView() implementation needed.")
    }
    
}

protocol FetchableSection: ConfigurableSection {
    var isLastPage: Bool { get }
    var didUpdate:((Error?) -> Void)? { get set }

    func refresh()
    func loadMore()
}
