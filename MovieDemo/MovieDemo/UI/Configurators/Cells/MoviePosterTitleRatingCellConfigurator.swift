//
//  MoviePosterTitleRatingCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MoviePosterTitleRatingCellConfigurator {
    func configure(cell: MoviePosterInfoCell, with movie: MovieViewModel) {
        cell.posterImageView.af.cancelImageRequest()
        cell.posterImageView.image = .asset(.PosterPlaceholder)
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.setRemoteImage(withURL: url)
        }
        
        cell.setPosterRatio((3/2))
        
        cell.title = movie.title
        cell.rating = movie.percentRating
        
        cell.loadViews()
    }
    
}

