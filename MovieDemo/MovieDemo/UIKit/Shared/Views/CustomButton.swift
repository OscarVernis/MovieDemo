//
//  CustomButton.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 23/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable
    var baseColor: UIColor = .systemPink {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set(cornerRadius) {
            layer.cornerRadius = cornerRadius
            updateView()
        }
    }
    
    @IBInspectable
    var showsBorder: Bool = false {
        didSet {
            updateView()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateView()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }
    
    func setIsSelected(_ selected: Bool, animated: Bool) {
        self.isSelected = selected
        
        if animated && selected {
            imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 20, options: []) { [weak self] in
                self?.imageView?.transform = CGAffineTransform.identity
            }

        }
    }
        
    override func awakeFromNib() {
        layer.cornerRadius = 12
        updateView()
    }
    
    fileprivate func updateView() {
        layer.masksToBounds = true
        layer.borderColor = baseColor.cgColor
        
        layer.borderWidth = showsBorder ? 1 : 0
        
        if isSelected {
            backgroundColor = baseColor.withAlphaComponent(0.2)
            setTitleColor(baseColor, for: .normal)
            tintColor = baseColor
        } else {
            backgroundColor = .asset(.DefaultButtonColor).withAlphaComponent(0.2)
            setTitleColor(baseColor, for: .normal)
            tintColor = baseColor
        }
    }

}
