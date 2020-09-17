//
//  CellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

public protocol CellConfigurator {
    associatedtype Cell: UICollectionViewCell
    associatedtype Model
    
    func configure(cell: Cell, with model: Model)
}
