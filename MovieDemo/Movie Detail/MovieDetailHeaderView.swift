//
//  MovieDetailHeaderView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailHeaderView: UICollectionReusableView {    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
        
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var imageTapHandler: (()->Void)? = nil

    override func awakeFromNib() {
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 12
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        posterImageView.addGestureRecognizer(tapRecognizer)
    }
        
    @objc func imageTapped(_ sender: Any) {
        imageTapHandler?()
    }
    
    func configure(movie: MovieViewModel) {
        if let url = movie.posterImageURL(size: .w342) {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        titleLabel.text = movie.title
        ratingsView.rating = CGFloat(movie.percentRating)
        ratingsView.isRatingAvailable = movie.isRatingAvailable
        ratingsLabel.text = movie.ratingString
        genresLabel.text = movie.genres(separatedBy: ", ")
        overviewLabel.text = movie.overview
        
        if let runtime = movie.runtime {
            releaseDateLabel.text = "\(movie.releaseYear)  •  \(runtime)"
        } else {
            releaseDateLabel.text = "\(movie.releaseYear)"
        }
    }
    
}
