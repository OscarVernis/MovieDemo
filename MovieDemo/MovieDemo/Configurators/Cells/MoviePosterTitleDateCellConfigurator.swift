//
//  MoviePosterTitleDateCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

struct MoviePosterTitleDateCellConfigurator {
    func configure(cell: MoviePosterInfoCell, with movie: MovieViewModel) {
        cell.posterImageView.af.cancelImageRequest()
        cell.posterImageView.image = UIImage(named: "PosterPlaceholder")
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        cell.setPosterRatio((3/2))
        
        cell.title = movie.title
        cell.info = movie.releaseDateWithoutYear
        
        cell.loadViews()
    }
    
}

