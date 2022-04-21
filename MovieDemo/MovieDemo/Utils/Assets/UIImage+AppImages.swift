//
//  UIImage+AppImages.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

enum AssetImage: String {
    case BackdropPlaceholder
    case PersonPlaceholder
    case PosterPlaceholder
    case Thumb
    
    var image: UIImage {
        UIImage(named: rawValue)!
    }
}

extension UIImage {
    static func asset(_ assetImage: AssetImage) -> UIImage {
        return assetImage.image
    }
    
}
