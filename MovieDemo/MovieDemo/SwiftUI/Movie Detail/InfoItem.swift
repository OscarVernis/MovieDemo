//
//  InfoListItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct InfoItem: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.custom("Avenir Medium", size: 16))
            Text(subtitle)
                .foregroundColor(.secondary)
                .font(.custom("Avenir Medium", size: 15))
            Divider()
        }
    }
}

struct InfoListItem_Previews: PreviewProvider {
    static var previews: some View {
        InfoItem(title: "Title", subtitle: "Subtitle")
            .background(Color(asset: .AppBackgroundColor))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
