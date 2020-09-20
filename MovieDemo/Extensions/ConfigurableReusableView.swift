//
//  ConfigurableReusableView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

protocol ConfigurableReusableView: UICollectionReusableView {
    static var reuseIdentifier: String { get }
    
    static func registerHeader(toCollectionView: UICollectionView, forSupplementaryViewOfKind: String)
}

extension ConfigurableReusableView {
    static func registerHeader(toCollectionView collectionView: UICollectionView, forSupplementaryViewOfKind kind: String = UICollectionView.elementKindSectionHeader) {
        collectionView.register(namedNib(), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
    }
}
