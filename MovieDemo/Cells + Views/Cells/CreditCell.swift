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
    
    func configure(castCredit: CastCreditViewModel) {
        creditImageView.af.cancelImageRequest()

        nameLabel.text = castCredit.name
        roleLabel.text = castCredit.character
        
        if let url = castCredit.profileImageURL {
            creditImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
    func configure(crewCredit: CrewCreditViewModel) {
        creditImageView.af.cancelImageRequest()
        
        nameLabel.text = crewCredit.name
        roleLabel.text = crewCredit.job
        
        if let url = crewCredit.profileImageURL {
            creditImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
