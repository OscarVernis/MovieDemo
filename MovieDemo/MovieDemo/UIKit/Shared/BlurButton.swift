//
//  BlurButton.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 09/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class BlurButton: UIButton {
    var blurView = UIVisualEffectView(effect: nil) 
    let blurStyle: UIBlurEffect.Style = .dark
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    fileprivate func setup() {
        layer.masksToBounds = true
        blurView.effect = UIBlurEffect(style: blurStyle)
        blurView.isUserInteractionEnabled = false
        addSubview(blurView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.midY

        blurView.frame = bounds
        sendSubviewToBack(blurView)
    }
}
