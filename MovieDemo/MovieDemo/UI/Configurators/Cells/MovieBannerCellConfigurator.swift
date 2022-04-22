//
//  MovieBannerCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieBannerCellConfigurator {
    func configure(cell: MovieBannerCell, withMovie movie: MovieViewModel) {
        cell.bannerImageView.cancelImageRequest()
        cell.bannerImageView.image = .asset(.BackdropPlaceholder)
        
        cell.titleLabel.text = movie.title
        
        cell.infoLabel.text = movie.genres()
        
        cell.ratingsView.rating = CGFloat(movie.percentRating)
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable
        
        if let url = movie.backdropImageURL(size: .w780) {
            cell.bannerImageView.setRemoteImage(withURL: url)
        }
    }
    
}
