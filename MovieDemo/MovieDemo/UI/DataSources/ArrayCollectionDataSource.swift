//
//  CollectionDataSource.swift
//  Test
//
//  Created by Oscar Vernis on 10/06/22.
//

import Foundation
import UIKit

class ArrayCollectionDataSource<Model>: NSObject, UICollectionViewDataSource {
    typealias CellConfigurator = (Model, UICollectionViewCell, IndexPath) -> Void

    var models: [Model]
        
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator?
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: CellConfigurator? = nil) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cellConfigurator?(model, cell, indexPath)
        
        return cell
    }
    
}
