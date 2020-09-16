//
//  RatingsView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

@IBDesignable
class RatingsView: UIStackView {
    
    @IBInspectable
    var isRatingAvailable: Bool = true {
        didSet { updateRating() }
    }
    
    @IBInspectable
    var rating: Float = 0 {
        didSet {
            if rating > 10 {
                rating = 10
            }
            
            if rating < 0 {
                rating = 0
            }
            
            updateRating()
        }
    }
    
    override func awakeFromNib() {
        spacing = 2
    }
    
    func updateRating() {
        for view in subviews {
            view.removeFromSuperview()
        }
        
        if !isRatingAvailable {
            self.alpha = 0.6
            
            addArrangedSubview(imageViewWithSymbol("slash.circle"))
            addArrangedSubview(imageViewWithSymbol("slash.circle"))
            addArrangedSubview(imageViewWithSymbol("slash.circle"))
            addArrangedSubview(imageViewWithSymbol("slash.circle"))
            addArrangedSubview(imageViewWithSymbol("slash.circle"))

            return
        }
        
        self.alpha = 1.0

        let halfRating = rating / 2
        for n in 0...4 {
            if halfRating >= Float(n) + 0.9 {
                addArrangedSubview(imageViewWithSymbol("circle.fill"))
            }
            else if halfRating >= Float(n) + 0.4, halfRating < Float(n) + 0.9  {
                addArrangedSubview(imageViewWithSymbol("circle.lefthalf.fill"))
            } else {
                addArrangedSubview(imageViewWithSymbol("circle"))
            }
        }
        
    }
    
    
    fileprivate func imageViewWithSymbol(_ name: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: name))
        imageView.tintColor = .systemOrange
        
        let ratioConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0)
        imageView.addConstraint(ratioConstraint)
        
        return imageView
    }
    
}
