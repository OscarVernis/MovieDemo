//
//  SectionTitle.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct SectionTitle: View {
    var title: String
    var font: Font
    
    init(title: String, font: Font = .sectionTitleFont) {
        self.title = title
        self.font = font
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(font)
                .foregroundColor(.label)
            Spacer()
            Button {
                print("ok")
            } label: {
                Text("SEE ALL")
                    .font(.sectionActionFont)
                    .foregroundColor(Color(asset: .AppTintColor))
            }
        }
        .frame(height: 40)
        .padding([.leading, .trailing], 20)
    }
    
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle(title: .localized(HomeString.NowPlaying))
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 44))
    }
}
