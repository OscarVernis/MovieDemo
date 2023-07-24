//
//  MoviePosterInfoCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MoviePosterInfoCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    var posterRatioConstraint: NSLayoutConstraint?
    
    var title: String?
    var rating: UInt?
    var info: String?
    
    override func awakeFromNib() {
        stackView.spacing = 0
        posterImageView.setupBorder()
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
        }
        
        if let rating = rating {
            let ratingsView = RatingsView()
            ratingsView.backgroundColor = .clear
            ratingsView.style = .line
            ratingsView.rating = CGFloat(rating)
            
            ratingsView.heightAnchor.constraint(equalToConstant: 6).isActive = true
            
            stackView.addArrangedSubview(ratingsView)
            stackView.setCustomSpacing(3, after: ratingsView)
        }
        
        if let secondaryInfo = info {
            let secondaryLabel = UILabel()
            secondaryLabel.font = UIFont(name: "Avenir-Medium", size: 14)
            secondaryLabel.textColor = .secondaryLabel
            secondaryLabel.numberOfLines = 1
            
            secondaryLabel.text = secondaryInfo
            stackView.addArrangedSubview(secondaryLabel)
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
        info = nil
    }
    
}

//MARK: - Configure
extension MoviePosterInfoCell {
    static func configureWithDate(cell: MoviePosterInfoCell, with movie: MovieViewModel) {
        cell.posterImageView.cancelImageRequest()
        cell.posterImageView.image = .asset(.PersonPlaceholder)
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PersonPlaceholder))
        }
        
        cell.setPosterRatio((3/2))
        
        cell.title = movie.title
        cell.info = movie.releaseDateWithoutYear
        
        cell.loadViews()
    }
    
    static func configureWithRating(cell: MoviePosterInfoCell, with movie: MovieViewModel) {
        cell.posterImageView.cancelImageRequest()
        cell.posterImageView.image = .asset(.PosterPlaceholder)
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PosterPlaceholder))
        }
        
        cell.setPosterRatio((3/2))
        
        cell.title = movie.title
        cell.rating = movie.percentRating
        
        cell.loadViews()
    }
    
}
