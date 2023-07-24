//
//  UIView+Border.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 24/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIView {
    func setupBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
    }
    
}
