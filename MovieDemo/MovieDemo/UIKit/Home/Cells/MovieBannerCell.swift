//
//  MovieBannerCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieBannerCell: UICollectionViewCell {    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        bannerImageView.setupBorder()
    }

    static func configure(cell: MovieBannerCell, with movie: MovieViewModel) {
        cell.bannerImageView.cancelImageRequest()
        cell.bannerImageView.image = .asset(.BackdropPlaceholder)
        
        cell.titleLabel.text = movie.title
        
        cell.infoLabel.text = movie.genres()
        
        cell.ratingsView.rating = CGFloat(movie.percentRating)
        cell.ratingsView.isRatingAvailable = movie.isRatingAvailable
        
        if let url = movie.backdropImageURL(size: .w780) {
            cell.bannerImageView.setRemoteImage(withURL: url, placeholder: .asset(.BackdropPlaceholder))
        }
    }
    
}
