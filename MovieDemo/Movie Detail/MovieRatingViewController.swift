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
            ratingLabel.text = "NR"
            slider.value = 0
        } else {
            ratingsView.rating = movie.userRating
            ratingLabel.text = "\(movie.userRating)"
            slider.value = Float(movie.userRating)
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
        ratingsView.isRatingAvailable = true
        ratingsView.rating = UInt(sender.value)
        ratingLabel.text = "\(ratingsView.rating)"
        ratingButton.isEnabled = true
    }
    
    @IBAction func rateButtonTapped(_ sender: Any) {
        isLoading = true
        
        movie.rate(Int(slider.value)) { [weak self] success in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if success {
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
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.presentingViewController?.dismiss(animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                AlertManager.showErrorAlert("Couldn't delete rating! Please try again.", sender: self)
            }
        }
        
    }
    
}
