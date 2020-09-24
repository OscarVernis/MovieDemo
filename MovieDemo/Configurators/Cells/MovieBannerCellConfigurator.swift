//
//  MovieBannerCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

struct MovieBannerCellConfigurator {
    func configure(cell: MovieBannerCell, withMovie movie: MovieViewModel) {
        cell.bannerImageView.af.cancelImageRequest()
        cell.bannerImageView.image = UIImage(named: "BackdropPlaceholder")
        
        cell.titleLabel.text = movie.title
        
        cell.infoLabel.text = movie.genres()
        
        cell.ratingsView.rating = Float(movie.percentRating)
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable
        
        if let url = movie.backdropImageURL(size: .w780) {
            cell.bannerImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
