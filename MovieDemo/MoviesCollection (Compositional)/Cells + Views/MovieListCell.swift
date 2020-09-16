//
//  MovieListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieListCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var ratingsView: RatingsView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withMovie movie: Movie, showSeparator: Bool = true) {
        titleLabel.text = movie.title
        
        if (movie.voteCount == nil || movie.voteCount == 0 || movie.voteAverage == nil) {
            ratingsView.isRatingAvailable = false
        } else {
            ratingsView.isRatingAvailable = true
            ratingsView.rating = movie.voteAverage!
        }
        
        separator.isHidden = !showSeparator
    }

}
