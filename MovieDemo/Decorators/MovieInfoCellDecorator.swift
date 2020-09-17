//
//  MovieInfoCellDecorator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieInfoCellDecorator {
    func configure(cell: MovieInfoCell, withMovie movie: MovieViewModel) {
        cell.posterImageView.af.cancelImageRequest()
        cell.posterImageView.image = UIImage(systemName: "film")
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        cell.titleLabel.text = movie.title
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable
        cell.ratingsView.rating = movie.rating
        cell.overviewLabel.text = movie.overview
        cell.genresLabel.text = movie.genresString
        cell.releaseDateLabel.text = movie.releaseYear
    }
    
}
