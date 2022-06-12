//
//  UserMoviesDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

class UserMoviesDataSource: ArrayCollectionDataSource<MovieViewModel> {
    var emptyMessage: NSAttributedString
    
    init(models: [MovieViewModel], emptyMessage: NSAttributedString) {
        self.emptyMessage = emptyMessage
        super.init(models: models, reuseIdentifier: "")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count > 0 ? models.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if models.count > 0 {
            let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
            
            let movie = models[indexPath.row]
            MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: movie)
            
            return posterCell
        } else {
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyMovieCell.reuseIdentifier, for: indexPath) as! EmptyMovieCell
            
            emptyCell.configure(message: emptyMessage)
            
            return emptyCell
        }
    }
    
}
