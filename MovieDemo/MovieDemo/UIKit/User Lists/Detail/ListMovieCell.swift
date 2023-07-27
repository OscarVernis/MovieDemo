//
//  ListMovieCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class ListMovieCell: UITableViewCell {

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

extension ListMovieCell {
    static func configure(cell: ListMovieCell, with movie: MovieViewModel) {
        cell.posterImageView.cancelImageRequest()
        cell.posterImageView.image = .asset(.PosterPlaceholder)
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PosterPlaceholder))
        }
        
        cell.titleLabel.text = movie.title
        
        cell.ratingsView.rating = CGFloat(movie.percentRating)
        cell.ratingsView.isHidden = !movie.isRatingAvailable
        
        cell.overviewLabel.text = movie.overview
        cell.overviewLabel.isHidden = movie.overview.isEmpty
        
        cell.genresLabel.text = movie.genres()
        cell.genresLabel.isHidden = cell.genresLabel.text!.isEmpty
        
        cell.releaseDateLabel.text = movie.releaseYear
        cell.releaseDateLabel.isHidden = movie.releaseYear.isEmpty
    }
}
