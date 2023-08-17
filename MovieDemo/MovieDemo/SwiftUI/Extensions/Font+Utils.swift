//
//  Font+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

extension Font {
    static func avenirNextMedium(size: CGFloat) -> Font {
        .custom("Avenir Next Medium", size: size)
    }
    
    static func avenirNextDemiBold(size: CGFloat) -> Font {
        .custom("Avenir Next Demi Bold", size: size)
    }
    
    static func avenirNextCondensedDemiBold(size: CGFloat) -> Font {
        .custom("Avenir Next Condensed Demi Bold", size: size)
    }
}

extension Font {
    static var titleFont: Font {
        .custom("Avenir Medium", size: 17.0)
    }
    
    static var subtitleFont: Font {
        .custom("Avenir Medium", size: 14.0)
    }
    
    static var sectionTitleFont: Font {
        .custom("Avenir Next Condensed Bold", size: 22.0)
    }
    
    static var sectionActionFont: Font {
        .custom("Avenir Next Bold", size: 13.0)
    }
    
    static var descriptionFont: Font {
        .custom("Avenir Light Oblique", size: 13.0)
    }
   
    static var detailSectionTitle: Font {
        .custom("Avenir Next Medium", size: 20.0)
    }
    
    static var movieDetailTitle: Font {
        .custom("Avenir Next Medium", size: 28.0)
    }
}

