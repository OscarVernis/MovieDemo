//
//  AttributedStringAsset.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

struct AttributedStringAsset {
    static var emptyFavoritesMessage: NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = .asset(.heart).withTintColor(.asset(.FavoriteColor))

        let fullString = NSMutableAttributedString(string: .localized(UserString.EmptyUserFavorites))
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: .localized(UserString.WillAppearMessage)))
        
        return fullString
    }
    
    static var emptyWatchlistMessage: NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = .asset(.bookmark).withTintColor(.asset(.WatchlistColor))
        
        let fullString = NSMutableAttributedString(string: .localized(UserString.EmptyUserWatchlist))
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: .localized(UserString.WillAppearMessage)))

        return fullString
    }
    
    static var emptyRatedMessage: NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = .asset(.star).withTintColor(.asset(.RatingColor))

        let fullString = NSMutableAttributedString(string: .localized(UserString.EmptyUserRated))
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: .localized(UserString.WillAppearMessage)))
        
        return fullString
    }
}
