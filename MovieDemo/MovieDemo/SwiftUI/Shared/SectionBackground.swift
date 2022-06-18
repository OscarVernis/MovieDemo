//
//  SectionBackground.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct SectionBackground<Content: View>: View {
    var content: () -> Content

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(asset: .SectionBackgroundColor))
            content()
        }
    }
}

//struct SectionBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        SectionBackground()
//    }
//}
