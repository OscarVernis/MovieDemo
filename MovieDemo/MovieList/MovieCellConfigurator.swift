//
//  MovieCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

struct MovieCellConfigurator {
    func configure(cell: MovieCell, withMovie movie: MovieViewModel) {
        cell.posterImageView.af.cancelImageRequest()
        cell.posterImageView.image = UIImage(systemName: "film")
        
        cell.titleLabel?.text = movie.title
        cell.overviewLabel?.text = movie.overview
        
        cell.ratingsView.rating = movie.rating
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable

        cell.posterImageView.layer.masksToBounds = true
        cell.posterImageView.layer.cornerRadius = 8
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView?.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        cell.genresLabel.text = movie.genresString
        
        cell.releaseLabel.text = movie.releaseYear
    }
    
}
