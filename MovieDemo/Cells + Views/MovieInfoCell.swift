//
//  MovieInfoCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieInfoCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieInfoCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 8
    }
    
    func configure(withMovie movie: MovieViewModel) {
        posterImageView.af.cancelImageRequest()
        posterImageView.image = UIImage(systemName: "film")
        
        if let url = movie.posterImageURL(size: .w342) {
            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        titleLabel.text = movie.title
        ratingsView.isRatingAvailable = movie.isRatingAvailable
        ratingsView.rating = movie.rating
        overviewLabel.text = movie.overview
        genresLabel.text = movie.genresString
        releaseDateLabel.text = movie.releaseYear
    }
    
}
