//
//  MovieInfoCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieInfoCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieInfoCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 8
    }
    
    func configure(withMovie movie: Movie) {
        if let url = movie.posterImageURL(size: .w342) {
            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
        
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.voteAverage!)"
        runtimeLabel.text = "\(movie.runtime ?? 0) m"
    }
}
