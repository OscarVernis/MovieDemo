//
//  BannerMovieCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class BannerMovieCell: UICollectionViewCell {
    static let reuseIdentifier = "BannerMovieCell"
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
    }
    
    func configureBackdrop(withMovie movie: Movie) {        
        let url = MovieDBService().backdropImageURL(forPath: movie.backdropPath!, size: .w780)
        bannerImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
    }
    
    func configurePoster(withMovie movie: Movie) {
        let url = MovieDBService().posterImageURL(forPath: movie.posterPath!, size: .w342)
        bannerImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
    }
    
}
