//
//  CreditListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class CreditListCell: UICollectionViewCell {
    static let reuseIdentifier = "CreditListCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(crewCredit: CrewCredit) {
        nameLabel.text = crewCredit.name
        jobLabel.text = crewCredit.job
    }

}
