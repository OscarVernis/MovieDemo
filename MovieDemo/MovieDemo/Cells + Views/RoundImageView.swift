//
//  RoundImageView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 12 {
        didSet {
            layer.cornerRadius = cornerRadius
            updateView()
        }
    }
    
    @IBInspectable
    var isCircle: Bool = false {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        updateView()
    }
    
    fileprivate func updateView() {
        layer.masksToBounds = true
       
        if isCircle {
            layer.cornerRadius = bounds.height / 2
        } else {
            layer.cornerRadius = cornerRadius
        }
        
    }
    
}
