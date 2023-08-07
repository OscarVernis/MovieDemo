//
//  MovieDetailHeaderView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class MovieDetailHeaderView: UICollectionReusableView {
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var userActionsView: UIView!
    @IBOutlet weak var overviewView: UIStackView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewTitleLabel: UILabel!
    
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
    
    
    @IBOutlet weak var playTrailerButton: CustomButton!
                
    var imageTapHandler: (()->Void)? = nil
    
    var gradient: CAGradientLayer!
    private var gradientCancellable: AnyCancellable?
    
    private(set) var isShowingPlaceholder = true
    private var isLoading = false
    
    private var movie: MovieViewModel!
    private var showUserActions = false
    
    override func awakeFromNib() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        posterImageView.addGestureRecognizer(tapRecognizer)
        
        containerStackView.setCustomSpacing(24, after: userActionsView)
        overviewView.setCustomSpacing(12, after: taglineLabel)
        
        //Gradient
        gradient = CAGradientLayer()
        gradient.frame = posterImageView.bounds
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.clear.cgColor]
        gradient.locations = [0.35, 0.85]
        posterImageView.layer.mask = gradient
        
        gradientCancellable = posterImageView.publisher(for: \.bounds)
            .sink { [weak self] bounds in
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self?.gradient.frame = bounds
                CATransaction.commit()
            }
    }
        
    @objc func imageTapped(_ sender: Any) {
        imageTapHandler?()
    }
    
    fileprivate func updateUserActionButtons(animated: Bool = false) {
        if !showUserActions { return }
        
        favoriteButton.isEnabled = !isLoading
        watchlistButton.isEnabled = !isLoading
        rateButton.isEnabled = !isLoading

        favoriteButton?.setIsSelected(movie.favorite, animated: animated)
        watchlistButton?.setIsSelected(movie.watchlist, animated: animated)
        rateButton?.setIsSelected(movie.rated, animated: animated)
    }
    
    func configure(movie: MovieViewModel, isLoading: Bool, showUserActions: Bool) {
        self.movie = movie
        self.isLoading = isLoading
        self.showUserActions = showUserActions

        //Load Poster image
        if isShowingPlaceholder, !posterImageView.isLoadingRemoteImage {
            let url = movie.posterImageURL(size: .original)
            posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PosterPlaceholder)) {
                self.isShowingPlaceholder = false
            }
        }
        
        //Movie Info
        titleLabel.text = movie.title
        taglineLabel.text = movie.tagline
        overviewLabel.text = movie.overview
        ratingsView.rating = CGFloat(movie.percentRating)
        ratingsView.isRatingAvailable = movie.isRatingAvailable
        ratingsLabel.text = movie.ratingString
        genresLabel.text = movie.genres(separatedBy: ", ")
        
        releaseDateLabel.text = "\(movie.releaseYear)"
        if let runtime = movie.runtime {
            releaseDateLabel.text?.append(contentsOf:"  •  \(runtime)")
        }
        
        //Hiding Header Sections
        userActionsView.isHidden = !showUserActions
        taglineLabel.isHidden = movie.tagline.isEmpty
        overviewTitleLabel.isHidden = movie.overview.isEmpty
        overviewLabel.isHidden = movie.overview.isEmpty
        overviewView.isHidden = movie.overview.isEmpty && movie.tagline.isEmpty
        trailerView.isHidden = (movie.trailerURL == nil)
        
        //Update User Action State
        updateUserActionButtons(animated: true)
        
        if isLoading {
            userActionsView.isHidden = true
            taglineLabel.isHidden = true
            overviewView.isHidden = true
            trailerView.isHidden = true
        }
    }

}
