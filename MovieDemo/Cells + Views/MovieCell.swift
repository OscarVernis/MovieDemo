//
//  MovieCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    static let reuseIdentifier = "MovieCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var releaseLabel: UILabel!
}
