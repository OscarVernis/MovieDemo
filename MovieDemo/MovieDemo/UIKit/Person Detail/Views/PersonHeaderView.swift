//
//  PersonHeaderView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class PersonHeaderView: UICollectionReusableView {
    static var headerkind = "PersonHeaderView.globalHeader"

    
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var separator: UIView!
    
    var gradient: CAGradientLayer!
    private var gradientCancellable: AnyCancellable?

    var blurAnimator: UIViewPropertyAnimator!
    
    override func awakeFromNib() {
        setupGradient()
        setupBlurAnimator()
    }
    
    fileprivate func setupGradient() {
        gradient = CAGradientLayer()
        gradient.frame = personImageView.bounds
        gradient.colors = [UIColor.black.cgColor,
                           UIColor.clear.cgColor]
        gradient.locations = [0.7, 1]
        personImageView.layer.mask = gradient
        
        gradientCancellable = personImageView.publisher(for: \.bounds)
            .sink { [weak self] bounds in
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self?.gradient.frame = bounds
                CATransaction.commit()
            }
    }
    
    fileprivate func setupBlurAnimator() {
        blurView.effect = nil
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
            self.blurView.effect = UIBlurEffect(style: .light)
            self.separator.alpha = 1
        }

        blurAnimator.pausesOnCompletion = true
    }
    
    deinit {
        blurAnimator?.stopAnimation(true)
    }
}
