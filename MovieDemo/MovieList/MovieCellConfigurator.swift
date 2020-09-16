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
    func configure(cell: MovieCell, withMovie movie: Movie) {
        cell.titleLabel?.text = movie.title
        cell.overviewLabel?.text = movie.overview
        
        cell.ratingsView.rating = movie.voteAverage ?? 0
        cell.ratingsView.isHidden = (movie.voteCount == nil || movie.voteCount == 0)

        cell.posterImageView?.image = nil
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView?.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
