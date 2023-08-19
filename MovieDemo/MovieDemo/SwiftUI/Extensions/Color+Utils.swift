//
//  Color+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

//MARK: - ColorAsset
extension Color {
    init(asset: ColorAsset) {
        let color = asset.color
        self.init(uiColor: color)
    }
    
    static func asset(_ asset: ColorAsset) -> Color {
        self.init(uiColor: asset.color)
    }
    
}

//MARK: - Standard Colors
extension Color {
    static let tertiary = Color(UIColor.tertiaryLabel.cgColor)
    static let quaternary = Color(UIColor.quaternaryLabel.cgColor)
    
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground.cgColor)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground.cgColor)
    
    static let systemFill = Color(UIColor.systemFill.cgColor)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill.cgColor)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill.cgColor)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill.cgColor)
    
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground.cgColor)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground.cgColor)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground.cgColor)
    
    static let systemGray = Color(UIColor.systemGray.cgColor)
    static let systemGray2 = Color(UIColor.systemGray2.cgColor)
    static let systemGray3 = Color(UIColor.systemGray3.cgColor)
    static let systemGray4 = Color(UIColor.systemGray4.cgColor)
    static let systemGray5 = Color(UIColor.systemGray5.cgColor)
    static let systemGray6 = Color(UIColor.systemGray6.cgColor)
    
    static let lightText = Color(UIColor.lightText.cgColor)
    static let darkText = Color(UIColor.darkText.cgColor)
    static let placeholderText = Color(UIColor.placeholderText)
    
    static let separator = Color(UIColor.separator.cgColor)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator.cgColor)
    static let link = Color(UIColor.link.cgColor)
}
