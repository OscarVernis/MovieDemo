//
//  MovieBannerCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieBannerCell: UICollectionViewCell {
    static let reuseIdentifier = "BannerMovieCell"
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerImageView.layer.masksToBounds = true
        bannerImageView.layer.cornerRadius = 12
    }
    
    func configure(withMovie movie: MovieViewModel) {
        bannerImageView.af.cancelImageRequest()
        bannerImageView.image = UIImage(systemName: "film")
        
        titleLabel.text = movie.title
        
        ratingsView.rating = movie.rating
        ratingsView.isRatingAvailable = movie.isRatingAvailable
        
        if let url = movie.backdropImageURL(size: .w780) {
            bannerImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
