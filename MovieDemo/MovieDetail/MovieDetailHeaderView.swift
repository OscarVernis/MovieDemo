//
//  MovieDetailHeaderView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "MovieDetailHeaderView"
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 12
    }
    
    func configure(movie: MovieViewModel) {
        if let url = movie.backdropImageURL(size: .w780) {
            backdropImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        if let url = movie.posterImageURL(size: .w342) {
            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        titleLabel.text = movie.title
        ratingsView.rating = movie.rating
        ratingsView.isRatingAvailable = movie.isRatingAvailable
        genresLabel.text = movie.genresString
        releaseDateLabel.text = movie.releaseYear
        overviewLabel.text = movie.overview
    }
}