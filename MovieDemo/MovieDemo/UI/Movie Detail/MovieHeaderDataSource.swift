//
//  MovieHeaderDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

class MovieHeaderDataSource: NSObject, UICollectionViewDataSource {
    let movie: MovieViewModel
    
    init(movie: MovieViewModel) {
        self.movie = movie
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieDetailHeaderView.reuseIdentifier, for: indexPath) as! MovieDetailHeaderView
        
            headerView.configure(movie: movie)

            return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (movie.isLoading == true) ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
    }
    
}
