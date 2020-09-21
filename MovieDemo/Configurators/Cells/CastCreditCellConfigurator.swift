//
//  CastCreditCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

import UIKit
import AlamofireImage

struct CastCreditCellConfigurator {
    func configure(cell: CreditCell, with castCredit: CastCreditViewModel) {
        cell.creditImageView.af.cancelImageRequest()

        cell.nameLabel.text = castCredit.name
        cell.roleLabel.text = castCredit.character
        
        if let url = castCredit.profileImageURL {
            cell.creditImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
