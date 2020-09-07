//
//  CollectionViewDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class CollectionViewDataSource<T: CollectionViewCellConfigurator>: NSObject, UICollectionViewDataSource {
    var models: [T.Model]
    var cellConfigurator: T
    
    private let reuseIdentifier: String
    
    init(models: [T.Model], configurator: T, reuseIdentifier: String) {
        self.models = models
        self.cellConfigurator = configurator
        self.reuseIdentifier = reuseIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! T.CellType
                
        cellConfigurator.configure(cell: cell, forModel: models[indexPath.row])
        
        return cell
    }
}
