//
//  Image+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

extension Image {
    init(asset: ImageAsset) {
        let image = asset.image.withRenderingMode(.alwaysTemplate)
        self.init(uiImage: image)
    }
    
}

