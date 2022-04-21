//
//  MovieInfoCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieInfoCellConfigurator: CellConfigurator {
    typealias Model = MovieViewModel
    typealias Cell = MovieInfoListCell
    
    func configure(cell: MovieInfoListCell, with movie: Model) {        
        cell.posterImageView.af.cancelImageRequest()
        cell.posterImageView.image = .asset(.PosterPlaceholder)
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.setRemoteImage(withURL: url)
        }
        
        cell.titleLabel.text = movie.title
        cell.ratingsView.rating = CGFloat(movie.percentRating)
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable
        cell.overviewLabel.text = movie.overview
        cell.genresLabel.text = movie.genres()
        cell.releaseDateLabel.text = movie.releaseYear
    }
    
}
