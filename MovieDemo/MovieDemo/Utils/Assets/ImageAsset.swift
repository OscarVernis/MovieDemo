//
//  AssetImage.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

enum ImageAsset: String, CaseIterable {
    //Assets Catalog
    case BackdropPlaceholder
    case PersonPlaceholder
    case PosterPlaceholder
    case Thumb
    
    //SF Symbols
    case heart = "heart.fill"
    case bookmark = "bookmark.fill"
    case star = "star.fill"
    case person = "person.crop.circle"
    case play = "play.fill"
    case pause = "pause.fill"
    
    var image: UIImage {
        switch self {
        case .heart, .bookmark, .star, .person, .play, .pause:
            return UIImage(systemName: rawValue)!
        default:
            return UIImage(named: rawValue)!
        }
    }
    
}

extension UIImage {
    static func asset(_ assetImage: ImageAsset) -> UIImage {
        return assetImage.image
    }
    
}
