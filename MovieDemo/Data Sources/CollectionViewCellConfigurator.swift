//
//  CellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

protocol CollectionViewCellConfigurator {
    associatedtype Model
    associatedtype CellType: UICollectionViewCell
    
    func configure(cell: CellType, forModel: Model)
}
