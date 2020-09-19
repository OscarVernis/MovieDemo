//
//  BannerRatingCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct BannerRatingCellConfigurator {
    func configure(cell: MoviePosterInfoCell, with model: MovieViewModel) {
        cell.posterImageView.af.cancelImageRequest()
        cell.posterImageView.image = UIImage(systemName: "film")
        
        if let url = model.backdropImageURL(size: .w780) {
            cell.posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
                
        cell.title = model.title
        cell.rating = model.percentRating

        cell.loadViews()
    }
    
}