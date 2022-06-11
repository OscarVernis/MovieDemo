//
//  TopRatedDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class TopRatedDataSource: ProviderDataSource<MoviesDataProvider> {
    var maxTopRated = 10
    
    init() {
        super.init(dataProvider: MoviesDataProvider(.TopRated),
                   reuseIdentifier: MovieRatingListCell.reuseIdentifier) { movie, cell, indexPath in
            guard let cell = cell as? MovieRatingListCell else { return }
                    
            MovieRatingListCellConfigurator().configure(cell: cell, withMovie: movie, showSeparator: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(maxTopRated, dataProvider.itemCount)
    }
}
