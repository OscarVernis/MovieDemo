//
//  MoviePosterCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Alamofire

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
    
    func configure(withMovie movie: Movie) {
        titleLabel.text = movie.title
        
        let dateFormatter = DateFormatter(withFormat: "MMM dd", locale: "en_US")
        if let releaseDate = movie.releaseDate {
            infoLabel.text = dateFormatter.string(from: releaseDate)
        }
        
        if let url = movie.posterImageURL(size: .w342) {
            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
}
