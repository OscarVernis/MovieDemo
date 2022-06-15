//
//  ConfigurableReusableView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static func registerHeader(withCollectionView collectionView: UICollectionView, forSupplementaryViewOfKind kind: String = UICollectionView.elementKindSectionHeader) {
        collectionView.register(namedNib(), forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
    }
}
