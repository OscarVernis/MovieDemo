//
//  MovieInfoListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieInfoListCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        posterImageView.setupBorder()
    }
}

extension MovieInfoListCell {
    static func configure(cell: MovieInfoListCell, with movie: MovieViewModel) {
        cell.posterImageView.cancelImageRequest()
        cell.posterImageView.image = .asset(.PosterPlaceholder)
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PosterPlaceholder))
        }
        
        cell.titleLabel.text = movie.title
        cell.ratingsView.rating = CGFloat(movie.percentRating)
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable
        cell.overviewLabel.text = movie.overview
        cell.genresLabel.text = movie.genres()
        cell.releaseDateLabel.text = movie.releaseYear
    }
}
