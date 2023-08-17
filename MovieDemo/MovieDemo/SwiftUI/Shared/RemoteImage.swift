//
//  RemoteImage.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI
import Kingfisher

struct RemoteImage: View {
    var url: URL?
    var placeholder: AnyView? = nil
    
    init(url: URL? = nil) {
        self.url = url
    }
    
    init<T: View>(url: URL? = nil, @ViewBuilder placeholder: () -> T) {
        self.url = url
        self.placeholder = AnyView(placeholder())
    }
    
    var body: some View {
        KFImage(url)
            .resizable()
            .placeholder { _ in
                placeholder
            }
            .fade(duration: 0.2)
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage()
    }
}
