//
//  MovieListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieListCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(withMovie movie: Movie, showSeparator: Bool = true) {
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.voteAverage!)"
        separator.isHidden = !showSeparator
    }

}
