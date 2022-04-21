//
//  CreditCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class CreditCell: UICollectionViewCell {
    @IBOutlet weak var creditImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func prepareForReuse() {
        creditImageView.image = UIImage(named: "PersonPlaceholder")
    }
    
}
