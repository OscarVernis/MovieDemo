//
//  LoadingCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        activityIndicator?.startAnimating()
    }
}
