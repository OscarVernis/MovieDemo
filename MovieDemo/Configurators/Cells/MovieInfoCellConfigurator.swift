//
//  MovieInfoCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieInfoCellConfigurator: CellConfigurator {
    typealias Model = Movie
    typealias Cell = MovieInfoListCell
    
    func configure(cell: MovieInfoListCell, with model: Model) {
        let viewModel = MovieViewModel(movie: model)
        
        cell.posterImageView.af.cancelImageRequest()
        cell.posterImageView.image = UIImage(named: "PosterPlaceholder")
        
        if let url = viewModel.posterImageURL(size: .w342) {
            cell.posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        cell.titleLabel.text = model.title
        cell.ratingsView.rating = viewModel.percentRating
        cell.ratingsView.isRatingAvailable = viewModel.isRatingAvailable
        cell.overviewLabel.text = viewModel.overview
        cell.genresLabel.text = viewModel.genresString()
        cell.releaseDateLabel.text = viewModel.releaseYear
    }
    
}
