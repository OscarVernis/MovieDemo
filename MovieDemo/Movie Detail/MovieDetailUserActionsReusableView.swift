//
//  MovieDetailUserActionsReusableView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 23/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailUserActionsReusableView: UICollectionReusableView {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    var favoriteSelected: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    var watchlistSelected: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    var ratedSelected: Bool = false {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteButton.layer.masksToBounds = true
        favoriteButton.layer.cornerRadius = 12
        favoriteButton.layer.borderColor = UIColor.systemPink.cgColor
        
        watchlistButton.layer.masksToBounds = true
        watchlistButton.layer.cornerRadius = 12
        watchlistButton.layer.borderColor = UIColor.systemOrange.cgColor
        
        rateButton.layer.masksToBounds = true
        rateButton.layer.cornerRadius = 12
        rateButton.layer.borderColor = UIColor.systemGreen.cgColor

        updateUI()
    }
    
    fileprivate func updateUI() {
        if favoriteSelected {
            favoriteButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
            favoriteButton.layer.borderWidth = 0
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.backgroundColor = .clear
            favoriteButton.layer.borderWidth = 1.0
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        if watchlistSelected {
            watchlistButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            watchlistButton.layer.borderWidth = 0
            watchlistButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            watchlistButton.backgroundColor = .clear
            watchlistButton.layer.borderWidth = 1.0
            watchlistButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        
        if ratedSelected {
            rateButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            rateButton.layer.borderWidth = 0
            rateButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            rateButton.backgroundColor = .clear
            rateButton.layer.borderWidth = 1.0
            rateButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

    
}
