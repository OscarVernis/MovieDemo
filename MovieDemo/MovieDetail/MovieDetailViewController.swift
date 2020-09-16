//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailViewController: UITableViewController {
    @IBOutlet weak var posterImageView: UIImageView!

    var movie: Movie? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        guard let movie = movie else { return }
        
        title = movie.title
        
        if let url = movie.posterImageURL(size: .w780) {
            posterImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
