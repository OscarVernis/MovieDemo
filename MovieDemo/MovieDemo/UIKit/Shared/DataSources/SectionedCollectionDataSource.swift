//
//  SectionedCollectionDataSource.swift
//  Test
//
//  Created by Oscar Vernis on 10/06/22.
//

import Foundation
import UIKit

class SectionedCollectionDataSource: NSObject, UICollectionViewDataSource {
    var dataSources: [UICollectionViewDataSource]
    
    init(dataSources: [UICollectionViewDataSource] = []) {
        self.dataSources = dataSources
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        
        return dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: 0)

        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
}
