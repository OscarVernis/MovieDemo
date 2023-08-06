//
//  EmptyMovieCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class EmptyMovieCell: UICollectionViewCell {

    @IBOutlet weak var messageLabel: UILabel!
}

extension EmptyMovieCell {
    static func configure(cell: EmptyMovieCell, message: NSAttributedString) {
        cell.messageLabel.attributedText = message
    }
}
