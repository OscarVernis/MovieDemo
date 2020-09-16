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
        cell.posterImageView.af.cancelImageRequest()
        cell.posterImageView.image = UIImage(systemName: "film")
        
        cell.titleLabel?.text = movie.title
        cell.overviewLabel?.text = movie.overview
        
        cell.ratingsView.rating = movie.voteAverage ?? 0
        cell.ratingsView.isRatingAvailable = !(movie.voteCount == nil || movie.voteCount == 0)

        cell.posterImageView.layer.masksToBounds = true
        cell.posterImageView.layer.cornerRadius = 8
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView?.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        let genres = movie.genres?.map { $0.string() } ?? []
        let genresString = genres.joined(separator: ", ")
        cell.genresLabel.text = genresString
        
        let dateFormatter = DateFormatter(withFormat: "yyyy", locale: "en_US")
        if let releaseDate = movie.releaseDate {
            cell.releaseLabel.text = dateFormatter.string(from: releaseDate)
        }
    }
    
}
