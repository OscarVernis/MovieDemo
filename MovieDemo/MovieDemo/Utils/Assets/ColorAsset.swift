//
//  AssetColor.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/09/20.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

enum ColorAsset: String, CaseIterable {
    case AppBackgroundColor
    case AppTintColor
    case FavoriteColor
    case RatingColor
    case SectionBackgroundColor
    case TextfieldBgColor
    case WatchlistColor
    
    var color: UIColor {
        UIColor(named: rawValue)!
    }
    
}

extension UIColor {
    static func asset(_ assetColor: ColorAsset) -> UIColor {
        return assetColor.color
    }
    
}
