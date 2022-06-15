//
//  Color+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

extension Color {
    init(asset: ColorAsset) {
        let color = asset.color
        self.init(uiColor: color)
    }
    
}
