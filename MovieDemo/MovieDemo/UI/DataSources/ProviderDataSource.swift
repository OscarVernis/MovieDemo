//
//  ProviderDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

class ProviderDataSource<Provider: ArrayDataProvider, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource {
    typealias CellConfigurator = (Cell, Provider.Model) -> Void
    
    var dataProvider: Provider
    private let cellConfigurator: CellConfigurator
    private let reuseIdentifier: String
        
    init(dataProvider: Provider,
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.dataProvider = dataProvider
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataProvider.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataProvider.item(atIndex: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Cell
        
        cellConfigurator(cell, model)
        
        return cell
    }
    
}
