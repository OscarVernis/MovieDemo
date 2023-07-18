//
//  TopRatedDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class TopRatedDataSource: ProviderDataSource<MoviesProvider, MovieRatingListCell> {
    var maxTopRated = 10
    
    init(provider: MoviesProvider) {
        super.init(dataProvider: provider,
                   reuseIdentifier: MovieRatingListCell.reuseIdentifier,
                   cellConfigurator: MovieRatingListCell.configure)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(maxTopRated, dataProvider.itemCount)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MovieRatingListCell
        
        let lastCellRow = min(maxTopRated, dataProvider.itemCount) - 1
        cell.separator.isHidden = (indexPath.row == lastCellRow)
        
        return cell
    }
    
}
