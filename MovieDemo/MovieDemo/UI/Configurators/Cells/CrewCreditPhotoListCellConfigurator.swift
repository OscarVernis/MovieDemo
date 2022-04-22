//
//  CrewCreditPhotoListCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct CrewCreditPhotoListCellConfigurator: CellConfigurator {
    typealias Model = CrewCreditViewModel
    typealias Cell = CreditPhotoListCell
    
    func configure(cell: Cell, with crewCredit: Model) {
        cell.creditImageView.cancelImageRequest()
        
        cell.nameLabel.text = crewCredit.name
        cell.roleLabel.text = crewCredit.job
        
        if let url = crewCredit.profileImageURL {
            cell.creditImageView.setRemoteImage(withURL: url)
        }
    }
    
}
