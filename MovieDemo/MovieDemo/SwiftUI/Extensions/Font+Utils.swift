//
//  Font+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

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
}

