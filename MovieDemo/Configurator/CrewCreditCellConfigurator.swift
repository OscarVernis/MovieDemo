//
//  CrewCreditCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct CrewCreditCellConfigurator: CellConfigurator {
    typealias Model = CrewCredit
    typealias Cell = CreditListCell
    
    func configure(cell: Cell, with model: Model) {
        cell.nameLabel.text = model.name
        cell.jobLabel.text = model.job
    }
    
}
