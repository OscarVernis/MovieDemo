//
//  MovieDetailsInfoCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 19/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieDetailsInfoCellConfigurator {
    func configure(cell: InfoListCell, info: [String : String]) {
        cell.titleLabel.text = info.first?.key
        cell.infoLabel.text = info.first?.value
    }
}
