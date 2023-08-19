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
    var tapAction: (() -> Void)?
    
    init(title: String, font: Font = .sectionTitleFont, tapAction: (() -> Void)? = nil) {
        self.title = title
        self.font = font
        self.tapAction = tapAction
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(font)
                .foregroundColor(.primary)
            Spacer()
            if let tapAction = tapAction {
                Button(action: tapAction) {
                    Text(HomeString.SeeAll.localized)
                        .font(.sectionActionFont)
                        .foregroundColor(Color(asset: .AppTintColor))
                }
            }
        }
        .padding([.leading, .trailing], 20)
        .frame(height: 40)
    }
    
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle(title: .localized(HomeString.NowPlaying), tapAction: {})
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 44))
    }
}
