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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var isLoading = false {
        didSet {
            updateUI()
        }
    }
    
    var movie: MovieViewModel!
    
    var didUpdateRating: (() -> Void)? = nil
    
    //MARK:- Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    fileprivate func setup() {
        ratingButton.layer.masksToBounds = true
        ratingButton.layer.cornerRadius = 8
        
        ratingsView.addTarget(self, action: #selector(ratingsViewValueChanged), for: .valueChanged)
        
        if !movie.rated {
            deleteRatingButton.isHidden = true
            ratingsView.isRatingAvailable = false
            ratingLabel.text = movie.userRatingString
        } else {
            ratingsView.rating = CGFloat(movie.percentUserRating)
            ratingLabel.text = movie.userRatingString
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
    
    //MARK:- Actions
    @objc func ratingsViewValueChanged() {
        var rating = (Double(ratingsView.rating) / 5).rounded(.down) * 5
        if rating < 5 {
            rating = 5
        }

        ratingsView.isRatingAvailable = true
        ratingLabel.text = "\(Int(rating))"
        ratingButton.isEnabled = true
    }

    @IBAction func rateButtonTapped(_ sender: Any) {
        isLoading = true
        let rating = (Double(ratingsView.rating) / 5).rounded(.down) * 5

        movie.rate(Int(rating)) { [weak self] success in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if success {
                self.didUpdateRating?()
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.presentingViewController?.dismiss(animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                AlertManager.showRatingAlert(text: NSLocalizedString("Couldn't set rating! Please try again.", comment: ""), sender: self)
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
                
                UISelectionFeedbackGenerator().selectionChanged()
                self.presentingViewController?.dismiss(animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                AlertManager.showRatingAlert(text: NSLocalizedString("Couldn't delete rating! Please try again.", comment: ""), sender: self)
                
            }
        }
        
    }
    
}
