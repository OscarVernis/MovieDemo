//
//  CreditPhotoListCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class CreditPhotoListCell: UICollectionViewCell {
    @IBOutlet weak var creditImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func prepareForReuse() {
        creditImageView.image = .asset(.PersonPlaceholder)
    }

}

//MARK: - Configure
extension CreditPhotoListCell {
    static func configure(cell: CreditPhotoListCell, with castCredit: CastCreditViewModel) {
        cell.creditImageView.cancelImageRequest()
        
        cell.nameLabel.text = castCredit.name
        cell.roleLabel.text = castCredit.character
        
        if let url = castCredit.profileImageURL {
            cell.creditImageView.setRemoteImage(withURL: url)
        }
    }
    
    static func configure(cell: CreditPhotoListCell, with crewCredit: CrewCreditViewModel) {
        cell.creditImageView.cancelImageRequest()
        
        cell.nameLabel.text = crewCredit.name
        cell.roleLabel.text = crewCredit.job
        
        if let url = crewCredit.profileImageURL {
            cell.creditImageView.setRemoteImage(withURL: url)
        }
    }
    
    static func configure(cell: CreditPhotoListCell, person: PersonViewModel) {
        cell.creditImageView.cancelImageRequest()
        
        cell.nameLabel.text = person.name
        cell.roleLabel.text = person.knownForMovies
        
        if let url = person.profileImageURL {
            cell.creditImageView.setRemoteImage(withURL: url)
        }
    }
    
}
