//
//  PersonCreditPhotoListConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct PersonCreditPhotoListConfigurator {
    func configure(cell: CreditPhotoListCell, person: Person) {
        let viewModel = PersonViewModel(person: person)
        
        cell.creditImageView.af.cancelImageRequest()
        
        cell.nameLabel.text = viewModel.name
        cell.roleLabel.text = viewModel.knownForMovies
        
        if let url = viewModel.profileImageURL {
            cell.creditImageView.af.setImage(withURL: url, imageTransition: .crossDissolve(0.3))
        }
    }
}
