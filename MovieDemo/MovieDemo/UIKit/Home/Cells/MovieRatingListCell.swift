//
//  MovieListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieRatingListCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    //MARK: - Configure
    static func configure(cell: MovieRatingListCell, withMovie movie: MovieViewModel) {
        cell.titleLabel.text = movie.title
        cell.ratingsLabel.text = movie.ratingString
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable
        cell.ratingsView.rating = CGFloat(movie.percentRating)
    }
    
}
