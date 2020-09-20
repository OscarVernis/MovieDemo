//
//  LoadingCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell, ConfigurableCell {
    static let reuseIdentifier = "LoadingCell"

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        activityIndicator.startAnimating()
    }
    
}
