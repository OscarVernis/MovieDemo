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
    
    fileprivate var totalItems: Int {
        min(maxTopRated, dataProvider.itemCount)
    }
    
    init(provider: MoviesProvider) {
        super.init(dataProvider: provider,
                   reuseIdentifier: MovieRatingListCell.reuseIdentifier,
                   cellConfigurator: MovieRatingListCell.configure)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItems
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MovieRatingListCell
        
        //Hide last separator
        cell.separator.isHidden = (indexPath.row == totalItems - 1)
        
        return cell
    }
    
}
