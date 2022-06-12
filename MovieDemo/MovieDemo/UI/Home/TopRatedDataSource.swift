//
//  TopRatedDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class TopRatedDataSource: ProviderDataSource<MoviesDataProvider, MovieRatingListCell> {
    var maxTopRated = 10
    
    init() {
        super.init(dataProvider: MoviesDataProvider(.TopRated),
                   reuseIdentifier: MovieRatingListCell.reuseIdentifier,
                   cellConfigurator: MovieRatingListCellConfigurator().configure)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(maxTopRated, dataProvider.itemCount)
    }
}
