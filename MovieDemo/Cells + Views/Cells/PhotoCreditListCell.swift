//
//  PhotoCreditListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PhotoCreditListCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCreditListCell"

    @IBOutlet weak var creditImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func prepareForReuse() {
        creditImageView.image = UIImage(systemName: "person.fill")
        creditImageView.contentMode = .scaleAspectFit
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        creditImageView.layer.masksToBounds = true
        creditImageView.layer.cornerRadius = 8
    }

}
