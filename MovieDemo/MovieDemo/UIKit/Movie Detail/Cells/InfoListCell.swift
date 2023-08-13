//
//  InfoListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class InfoListCell: UICollectionViewCell {    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var separator: UIView!
}

//MARK: - Configure
extension InfoListCell {
    static func configure(cell: InfoListCell, with crewCredit: CrewCreditViewModel) {
        cell.titleLabel.text = crewCredit.name
        cell.infoLabel.text = crewCredit.jobs
        cell.infoLabel.font = cell.infoLabel.font.withSize(15)
    }
    
    static func configure(cell: InfoListCell, info: [String : String]) {
        cell.titleLabel.text = info.first?.key
        cell.infoLabel.text = info.first?.value
        cell.infoLabel.font = cell.infoLabel.font.withSize(16)
    }
    
    static func configureWithoutSeparator(cell: InfoListCell, info: [String : String]) {
        configure(cell: cell, info: info)
        cell.separator.isHidden = true
    }
}
