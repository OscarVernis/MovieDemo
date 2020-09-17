//
//  MoviePosterCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviePosterCell: UICollectionViewCell {
    static let reuseIdentifier = "MoviePosterCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 12
    }
    
    func configure(withMovie movie: MovieViewModel) {
        posterImageView.af.cancelImageRequest()
        posterImageView.image = UIImage(systemName: "film")
        
        titleLabel.text = movie.title
        infoLabel.text = movie.releaseDateWithoutYear
        
        if let url = movie.posterImageURL(size: .w342) {
            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
