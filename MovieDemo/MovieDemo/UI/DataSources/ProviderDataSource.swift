//
//  ProviderDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

class ProviderDataSource<Provider: ArrayDataProvider>: NSObject, UICollectionViewDataSource {
    typealias CellConfigurator = (Provider.Model, UICollectionViewCell, IndexPath) -> Void
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cellConfigurator(model, cell, indexPath)
        
        return cell
    }
    
}
