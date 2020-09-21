//
//  CrewCreditInfoListCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 19/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

struct CrewCreditInfoListCellConfigurator {
    func configure(cell: InfoListCell, with model: [String: String]) {
        cell.titleLabel.text = model.first?.key
        cell.infoLabel.text = model.first?.value
    }
    
}
