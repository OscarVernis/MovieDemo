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

extension UICollectionView {
    func cell<Cell: UICollectionViewCell, Model>(at indexPath: IndexPath, model: Model, cellConfigurator: ((Cell, Model) -> ())? = nil) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        
        cellConfigurator?(cell, model)
        
        return cell
    }
}
