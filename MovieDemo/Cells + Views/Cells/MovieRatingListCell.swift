//
//  MovieListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieRatingListCell: UICollectionViewCell, ConfigurableCell {
    static let reuseIdentifier = "MovieRatingListCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    func configure(withMovie movie: MovieViewModel, showSeparator: Bool = true) {
        titleLabel.text = movie.title
        
        ratingsLabel.text = movie.ratingString
        
        ratingsView.isRatingAvailable = movie.isRatingAvailable
        ratingsView.rating = movie.percentRating
        
        separator.isHidden = !showSeparator
    }

}
