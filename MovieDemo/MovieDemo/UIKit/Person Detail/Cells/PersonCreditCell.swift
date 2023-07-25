//
//  PersonCreditCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonCreditCell: UICollectionViewCell {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var posterImageView: RoundImageView!
    
    override func prepareForReuse() {
        posterImageView.cancelImageRequest()
        posterImageView.image = .asset(.PosterPlaceholder)
    }
}

extension PersonCreditCell {
    static func configure(cell: PersonCreditCell, castCredit: PersonCastCreditViewModel) {
        cell.titleLabel.text = castCredit.title
        
        cell.yearLabel.text = castCredit.year
        cell.yearLabel.isHidden = castCredit.year == nil

        cell.creditLabel.text = castCredit.character
        cell.creditLabel.isHidden = castCredit.character == nil
        
        if let url = castCredit.movie?.posterImageURL(size: .w185) {
            cell.posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PosterPlaceholder))
        }
    }
    
    static func configure(cell: PersonCreditCell, crewCredit: PersonCrewCreditViewModel) {
        cell.titleLabel.text = crewCredit.title
        
        cell.yearLabel.text = crewCredit.year
        cell.yearLabel.isHidden = crewCredit.year == nil
        
        cell.creditLabel.text = crewCredit.job
        cell.creditLabel.isHidden = crewCredit.job == nil
        
        if let url = crewCredit.movie?.posterImageURL(size: .w185) {
            cell.posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PosterPlaceholder))
        }
    }
}
