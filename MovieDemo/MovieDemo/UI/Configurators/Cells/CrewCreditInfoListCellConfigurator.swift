//
//  CrewCreditInfoListCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 19/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct CrewCreditInfoListCellConfigurator {
    func configure(cell: InfoListCell, with infoDict: [String: String]) {
        cell.titleLabel.text = infoDict.first?.key
        cell.infoLabel.text = infoDict.first?.value
        cell.separator.isHidden = true
    }
    
    func configure(cell: InfoListCell, with crewCredit: CrewCreditViewModel) {
        
        cell.titleLabel.text = crewCredit.name
        cell.infoLabel.text = crewCredit.jobs
    }
    
}
