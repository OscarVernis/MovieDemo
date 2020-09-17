//
//  CastCreditCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import AlamofireImage

struct CastCreditCellConfigurator: CellConfigurator {
    typealias Model = CastCredit
    typealias Cell = PhotoCreditListCell
    
    func configure(cell: Cell, with model: Model) {
        cell.creditImageView.af.cancelImageRequest()
        
        cell.nameLabel.text = model.name
        cell.roleLabel.text = model.character
        
        if let pathString = model.profilePath {
            let url = MovieDBService.profileImageURL(forPath: pathString, size: .h632)
            cell.creditImageView.contentMode = .scaleAspectFill
            cell.creditImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
    
}
