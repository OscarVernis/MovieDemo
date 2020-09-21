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
    func configure(cell: InfoListCell, with model: CrewCreditViewModel) {
        
        cell.titleLabel.text = model.name
        cell.infoLabel.text = model.jobs
    }
    
}
