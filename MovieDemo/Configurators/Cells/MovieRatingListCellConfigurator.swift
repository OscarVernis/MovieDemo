//
//  MovieRatingListCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieRatingListCellConfigurator {
    func configure(cell: MovieRatingListCell, withMovie movie: MovieViewModel, showSeparator: Bool = true) {
        cell.titleLabel.text = movie.title
        
        cell.ratingsLabel.text = movie.ratingString
        
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable
        cell.ratingsView.rating = movie.percentRating
        
        cell.separator.isHidden = !showSeparator
    }
}
