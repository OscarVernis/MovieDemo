//
//  OverviewCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class OverviewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.systemBackground.withAlphaComponent(0).cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.startPoint = CGPointMake(0, 0.5)
        gradientLayer.endPoint = CGPointMake(1, 0.5)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    var isExpanded: Bool = false {
        didSet {
            textLabel.numberOfLines = isExpanded ? 0 : 10
            expandButton.isHidden = isExpanded || !textLabel.isTruncated
            gradientView.isHidden = expandButton.isHidden
            
        }
    }
    
}
