//
//  UIView+Nib.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIView {
    static func namedNib(bundle: Bundle = .main) -> UINib {
        return UINib(nibName: String(String(describing: self)), bundle: bundle)
    }
}
