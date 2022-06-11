//
//  CollectionDataSource.swift
//  Test
//
//  Created by Oscar Vernis on 10/06/22.
//

import Foundation
import UIKit

class ArrayCollectionDataSource<Model, C: CellConfigurator>: NSObject, UICollectionViewDataSource {
    var models: [Model]
        
    private let reuseIdentifier: String
    private let cellConfigurator: C
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: C) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row] as! C.Model
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cellConfigurator.configure(cell: cell as! C.Cell, with: model)
        
        return cell
    }
    
}
