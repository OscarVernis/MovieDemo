//
//  MoviePosterInfoCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MoviePosterInfoCell: UICollectionViewCell {
    static let reuseIdentifier = "MoviePosterInfoCell"

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    var posterRatioConstraint: NSLayoutConstraint?
    
    var title: String?
    var rating: Float?
    var secondaryInfo: String?
    var tertiaryInfo: String?
    
    override func awakeFromNib() {
        stackView.spacing = 2

        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 12
    }
    
    func setPosterRatio(_ ratio: CGFloat) {
        if posterRatioConstraint != nil {
            posterImageView.removeConstraint(posterRatioConstraint!)
        }
        
        posterRatioConstraint = NSLayoutConstraint(item: posterImageView!,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: posterImageView!,
                                                   attribute: .width,
                                                   multiplier: ratio,
                                                   constant: 0)
        
        posterImageView.addConstraint(posterRatioConstraint!)
        posterRatioConstraint!.isActive = true
    }
        
    func loadViews() {
        removeViews()
                        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.font = UIFont(name: "Avenir-Medium", size: 17)
            titleLabel.textColor = .label
            titleLabel.numberOfLines = 1
            
            titleLabel.text = title
            stackView.addArrangedSubview(titleLabel)
            stackView.setCustomSpacing(3, after: titleLabel)
        }
        
        if let rating = rating {
            let ratingsView = RatingsView()
            ratingsView.backgroundColor = .clear
            ratingsView.rating = rating
            
            ratingsView.heightAnchor.constraint(equalToConstant: 10).isActive = true
            
            stackView.addArrangedSubview(ratingsView)
            stackView.setCustomSpacing(3, after: ratingsView)
        }
        
        if let secondaryInfo = secondaryInfo {
            let secondaryLabel = UILabel()
            secondaryLabel.font = UIFont(name: "Avenir-Medium", size: 14)
            secondaryLabel.textColor = .secondaryLabel
            secondaryLabel.numberOfLines = 1
            
            secondaryLabel.text = secondaryInfo
            stackView.addArrangedSubview(secondaryLabel)
            stackView.setCustomSpacing(3, after: secondaryLabel)
        }
        
        if let tertiaryInfo = tertiaryInfo {
            let tertiaryLabel = UILabel()
            tertiaryLabel.font = UIFont(name: "Avenir-Medium", size: 14)
            tertiaryLabel.textColor = .secondaryLabel
            tertiaryLabel.numberOfLines = 1
            
            tertiaryLabel.text = tertiaryInfo
            stackView.addArrangedSubview(tertiaryLabel)
            stackView.setCustomSpacing(3, after: tertiaryLabel)
        }
        
    }
    
    private func removeViews() {
        for subview in stackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    
    override func prepareForReuse() {
        removeViews()
        
        title = nil
        rating = nil
        secondaryInfo = nil
        tertiaryInfo = nil
    }
    
}
