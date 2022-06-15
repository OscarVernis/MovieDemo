//
//  ConfigurableCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static func register(to collectionView: UICollectionView) {
        collectionView.register(namedNib(), forCellWithReuseIdentifier: reuseIdentifier)
    }
}
