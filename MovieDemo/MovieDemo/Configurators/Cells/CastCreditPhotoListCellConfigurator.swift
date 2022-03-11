//
//  CastCreditPhotoListCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct CastCreditPhotoListCellConfigurator: CellConfigurator {
    typealias Model = CastCreditViewModel
    typealias Cell = CreditPhotoListCell
    
    func configure(cell: Cell, with castCredit: Model) {
        cell.creditImageView.af.cancelImageRequest()
        
        cell.nameLabel.text = castCredit.name
        cell.roleLabel.text = castCredit.character
        
        if let url = castCredit.profileImageURL {
            cell.creditImageView.setRemoteImage(withURL: url)
        }
    }
    
}
