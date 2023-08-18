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
    case user = "person.circle"
    case play = "play.fill"
    case pause = "pause.fill"
    case trailer = "play.circle.fill"
    case back = "arrow.left"
    case tv = "tv"
    case updownchevron = "chevron.up.chevron.down"
    case justWatchLogo = "JustWatch-logo"
    case tmdbLogo = "TMDB-logo"
    
    var image: UIImage {
        switch self {
        case .BackdropPlaceholder, .PersonPlaceholder, .PosterPlaceholder, .Thumb, .justWatchLogo, .tmdbLogo:
            return UIImage(named: rawValue)!
        default:
            return UIImage(systemName: rawValue)!
        }
    }
    
}

extension UIImage {
    static func asset(_ assetImage: ImageAsset) -> UIImage {
        return assetImage.image
    }
    
}
