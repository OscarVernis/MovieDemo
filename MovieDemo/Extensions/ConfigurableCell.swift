//
//  ConfigurableCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

protocol ConfigurableCell: UICollectionViewCell {
    static var reuseIdentifier: String { get }
    
    static func register(withCollectionView collectionView: UICollectionView)
}

extension ConfigurableCell {
    static func register(withCollectionView collectionView: UICollectionView) {
        collectionView.register(namedNib(), forCellWithReuseIdentifier: reuseIdentifier)
    }
}
