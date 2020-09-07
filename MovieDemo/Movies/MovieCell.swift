//
//  MovieCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: Movie? {
        didSet{
            configureCell()
        }
    }
    
    func configureCell() {
        guard let movie = movie else {
            return
        }
        
        titleLabel?.text = movie.title
        overviewLabel?.text = movie.overview
        
        posterImageView?.image = nil
        if let posterPath = movie.posterPath {
            let url = MovieDBService.posterImageURL(forPath: posterPath, size: .w342)
            posterImageView?.af_setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }

}
