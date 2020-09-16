//
//  MovieInfoCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieInfoCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieInfoCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 8
    }
    
    func configure(withMovie movie: Movie) {
        posterImageView.af.cancelImageRequest()
        posterImageView.image = UIImage(systemName: "film")
        
        if let url = movie.posterImageURL(size: .w342) {
            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        titleLabel.text = movie.title
        
        if (movie.voteCount == nil || movie.voteCount == 0 || movie.voteAverage == nil) {
            ratingsView.isRatingAvailable = false
        } else {
            ratingsView.isRatingAvailable = true
            ratingsView.rating = movie.voteAverage!
        }
        
        overviewLabel.text = movie.overview

        let genres = movie.genres?.map { $0.string() } ?? []
        let genresString = genres.joined(separator: ", ")
        genresLabel.text = genresString
        
        let dateFormatter = DateFormatter(withFormat: "yyyy", locale: "en_US")
        if let releaseDate = movie.releaseDate {
            releaseDateLabel.text = dateFormatter.string(from: releaseDate)
        }
    }
}
