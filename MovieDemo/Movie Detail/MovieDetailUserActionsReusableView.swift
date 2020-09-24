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
        favoriteButton.baseColor = #colorLiteral(red: 0.8588235294, green: 0.137254902, blue: 0.3764705882, alpha: 1)
        
        watchlistButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        watchlistButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        watchlistButton.baseColor = .systemOrange

        rateButton.setImage(UIImage(systemName: "star"), for: .normal)
        rateButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        rateButton.baseColor = #colorLiteral(red: 0.1294117647, green: 0.8156862745, blue: 0.4823529412, alpha: 1)
    }
    
}
