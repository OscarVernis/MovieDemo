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
    
    weak var coordinator: MainCoordinator? = nil
    
    private var isLoading = false {
        didSet {
            updateUI()
        }
    }
    
    var store: MovieDetailStore!
    var movie: MovieViewModel {
        store.movie
    }
    
    var didUpdateRating: (() -> Void)? = nil
    
    //MARK: - Setup
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
    
    //MARK: - Actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
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

        store.rate(Int(rating)) { [weak self] success in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if success {
                self.didUpdateRating?()
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                self.presentingViewController?.dismiss(animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                self.coordinator?.handle(error: .ratingError)
            }
        }
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        isLoading = true
        
        store.deleteRate { [weak self] success in
            guard let self = self else { return }
    
            self.isLoading = false
            
            if success {
                self.didUpdateRating?()
                
                UISelectionFeedbackGenerator().selectionChanged()
                self.presentingViewController?.dismiss(animated: true)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                self.coordinator?.handle(error: .deleteRatingError)
            }
        }
        
    }
    
}
