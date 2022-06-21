//
//  BlurBackground.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct BlurBackground: View {
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        ZStack {
            RemoteImage(url: url)
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .clipped()
                .edgesIgnoringSafeArea(.all)
            Rectangle()
                .fill(.clear)
                .background(.thickMaterial)
        }
    }
    
}
