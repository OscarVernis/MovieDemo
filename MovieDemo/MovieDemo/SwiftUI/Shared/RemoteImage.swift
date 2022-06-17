//
//  RemoteImage.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RemoteImage: View {
    var url: URL?
    var placeholder: Image?
    
    var body: some View {
        WebImage(url: url)
            .placeholder {
                if let placeholder = placeholder {
                    placeholder
                        .resizable()
//                        .scaledToFit()
                        .cornerRadius(12)
                }
            }
            .resizable()
            .scaledToFit()
            .transition(.fade(duration: 0.5))
            .cornerRadius(12)
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage()
    }
}
