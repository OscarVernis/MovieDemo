//
//  OverviewDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 13/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class OverviewDataSource: NSObject, UICollectionViewDataSource {
    var overview: String
    
    init(overview: String) {
        self.overview = overview
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.reuseIdentifier, for: indexPath) as! OverviewCell
        
        cell.textLabel.text = overview
        
        return cell
    }
    
}
