//
//  PersonCreditCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonCreditCell: UICollectionViewCell {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
}

extension PersonCreditCell {
    static func configure(cell: PersonCreditCell, castCredit: PersonCastCreditViewModel) {
        cell.yearLabel.text = castCredit.year
        cell.titleLabel.text = castCredit.title
        
        cell.creditLabel.text = castCredit.character
        cell.creditLabel.isHidden = castCredit.character == nil
    }
    
    static func configure(cell: PersonCreditCell, crewCredit: PersonCrewCreditViewModel) {
        cell.yearLabel.text = crewCredit.year
        cell.titleLabel.text = crewCredit.title
        
        cell.creditLabel.text = crewCredit.job
        cell.creditLabel.isHidden = crewCredit.job == nil
    }
}
