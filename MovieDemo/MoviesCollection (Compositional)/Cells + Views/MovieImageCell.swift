//
//  MovieImageCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieImageCell: UICollectionViewCell {
    static let reuseIdentifier = "BannerMovieCell"
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
    }
    
    func configureBackdrop(withMovie movie: Movie) {        
        if let url = movie.backdropImageURL(size: .w780) {
            bannerImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
    func configurePoster(withMovie movie: Movie) {
        if let url = movie.posterImageURL(size: .w342) {
            bannerImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
