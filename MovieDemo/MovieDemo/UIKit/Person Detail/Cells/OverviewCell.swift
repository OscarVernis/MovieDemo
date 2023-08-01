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
    private var gradientLayer = CAGradientLayer()

    var minNumberOfLines = 10
    
    override func awakeFromNib() {
        setupGradient()
        expandButton.setTitle(.localized(PersonString.SeeMore), for: .normal)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.systemBackground.withAlphaComponent(0).cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.startPoint = CGPointMake(0, 0.5)
        gradientLayer.endPoint = CGPointMake(1, 0.5)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        setupLabel()
    }
    
    func setupLabel() {
        textLabel.numberOfLines = isExpanded ? 0 : minNumberOfLines
        expandButton.isHidden = isExpanded || !textLabel.isTruncated
        gradientView.isHidden = expandButton.isHidden
    }
    
    var isExpanded: Bool = false {
        didSet {
            setupLabel()
        }
    }
    
}
