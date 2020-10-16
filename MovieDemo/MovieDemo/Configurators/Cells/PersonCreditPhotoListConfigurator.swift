//
//  PersonCreditPhotoListConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct PersonCreditPhotoListConfigurator {
    func configure(cell: CreditPhotoListCell, person: PersonViewModel) {        
        cell.creditImageView.af.cancelImageRequest()
        
        cell.nameLabel.text = person.name
        cell.roleLabel.text = person.knownForMovies
        
        if let url = person.profileImageURL {
            cell.creditImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
}
