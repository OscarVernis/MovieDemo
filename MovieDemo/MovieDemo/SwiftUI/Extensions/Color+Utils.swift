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
    
}

//MARK: - Standard Colors
extension Color {
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let separator = Color(UIColor.separator)
}
