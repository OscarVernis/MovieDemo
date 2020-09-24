//
//  MovieDetailUserActionsReusableView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 23/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailUserActionsReusableView: UICollectionReusableView {
    @IBOutlet weak var favoriteButton: CustomButton!
    @IBOutlet weak var watchlistButton: CustomButton!
    @IBOutlet weak var rateButton: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        favoriteButton.baseColor = .systemPink
        
        watchlistButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        watchlistButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        watchlistButton.baseColor = .systemOrange

        rateButton.setImage(UIImage(systemName: "star"), for: .normal)
        rateButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        rateButton.baseColor = .systemGreen
    }
    
}
