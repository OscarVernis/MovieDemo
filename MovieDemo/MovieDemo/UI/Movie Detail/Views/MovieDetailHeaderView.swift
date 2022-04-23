//
//  MovieDetailHeaderView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailHeaderView: UICollectionReusableView {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    @IBOutlet weak var container: UIStackView!
    @IBOutlet weak var userActionsView: UIView!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var trailerView: UIView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: CustomButton!
    @IBOutlet weak var watchlistButton: CustomButton!
    @IBOutlet weak var rateButton: CustomButton!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var playTrailerButton: CustomButton!
                
    var imageTapHandler: (()->Void)? = nil

    override func awakeFromNib() {        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        posterImageView.addGestureRecognizer(tapRecognizer)
    }
        
    @objc func imageTapped(_ sender: Any) {
        imageTapHandler?()
    }
    
    func configure(movie: MovieViewModel, showsUserActions: Bool = false) {
        //Load Poster image
        if let url = movie.posterImageURL(size: .w342) {
            posterImageView.contentMode = .scaleAspectFill
            posterImageView.setRemoteImage(withURL: url)
        }
        
        //Movie Info
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        ratingsView.rating = CGFloat(movie.percentRating)
        ratingsView.isRatingAvailable = movie.isRatingAvailable
        ratingsLabel.text = movie.ratingString
        genresLabel.text = movie.genres(separatedBy: ", ")
        
        if let runtime = movie.runtime {
            releaseDateLabel.text = "\(movie.releaseYear)  •  \(runtime)"
        } else {
            releaseDateLabel.text = "\(movie.releaseYear)"
        }
        
        //Hiding Header Sections
        userActionsView.isHidden = !showsUserActions
        overviewView.isHidden = movie.overview.isEmpty
        trailerView.isHidden = (movie.trailerURL == nil)
    }

    
}
