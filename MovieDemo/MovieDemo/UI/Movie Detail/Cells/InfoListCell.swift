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
    }
    
    static func configure(cell: InfoListCell, info: [String : String]) {
        cell.titleLabel.text = info.first?.key
        cell.infoLabel.text = info.first?.value
    }
}
