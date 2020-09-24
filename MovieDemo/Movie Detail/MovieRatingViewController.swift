//
//  MovieRatingViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 23/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieRatingViewController: UIViewController {
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var deleteRatingButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var isLoading = false {
        didSet {
            updateUI()
        }
    }
    
    var movie: MovieViewModel!
    
    var didUpdateRating: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    fileprivate func setup() {
        ratingButton.layer.masksToBounds = true
        ratingButton.layer.cornerRadius = 8
        
        if !movie.rated {
            deleteRatingButton.isHidden = true
            
            ratingsView.isRatingAvailable = false
            ratingLabel.text = movie.userRatingString
            slider.value = 0
        } else {
            ratingsView.rating = movie.percentUserRating
            ratingLabel.text = movie.userRatingString
            slider.value = Float(movie.percentUserRating)
        }
        
    }
    
    fileprivate func updateUI() {
        if isLoading {
            activityIndicator.isHidden = false
            ratingButton.isEnabled = false
            ratingButton.titleLabel?.alpha = 0
            deleteRatingButton.isEnabled = false
        } else {
            activityIndicator.isHidden = true
            ratingButton.isEnabled = true
            ratingButton.titleLabel?.alpha = 1
            deleteRatingButton.isEnabled = true
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let rating = (slider.value / 5).rounded(.down) * 5
        
        ratingsView.isRatingAvailable = true
        ratingsView.rating = UInt(rating)
        ratingLabel.text = "\(Int(rating))"
        ratingButton.isEnabled = true
    }
    
    @IBAction func rateButtonTapped(_ sender: Any) {
        isLoading = true
        let rating = (slider.value / 5).rounded(.down) * 5

        movie.rate(Int(rating)) { [weak self] success in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if success {
                self.didUpdateRating?()
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.presentingViewController?.dismiss(animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                AlertManager.showErrorAlert("Couldn't set rating! Please try again.", sender: self)
            }
        }
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        isLoading = true
        
        movie.deleteRate { [weak self] success in
            guard let self = self else { return }
    
            self.isLoading = false
            
            if success {
                self.didUpdateRating?()
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.presentingViewController?.dismiss(animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                AlertManager.showErrorAlert("Couldn't delete rating! Please try again.", sender: self)
            }
        }
        
    }
    
}
