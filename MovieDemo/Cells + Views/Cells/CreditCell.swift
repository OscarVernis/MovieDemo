//
//  CreditCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

class CreditCell: UICollectionViewCell {
    @IBOutlet weak var creditImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func awakeFromNib() {
        creditImageView.layer.masksToBounds = true
        creditImageView.layer.cornerRadius = 12
    }
    
    override func prepareForReuse() {
        creditImageView.image = UIImage(named: "PersonPlaceholder")
    }
    
}
