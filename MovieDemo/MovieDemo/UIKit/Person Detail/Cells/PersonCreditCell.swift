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
    static func configure(cell: PersonCreditCell, credit: PersonCreditViewModel) {
        cell.titleLabel.text = credit.title
        
        cell.yearLabel.text = credit.year
        cell.yearLabel.isHidden = credit.year.isEmpty
        
        cell.creditLabel.text = credit.job
        cell.creditLabel.isHidden = credit.job == nil
        
        if let url = credit.movie?.posterImageURL(size: .w185) {
            cell.posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PosterPlaceholder))
        }
    }
}
