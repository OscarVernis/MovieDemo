//
//  InfoListItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct InfoItemModel: Hashable {
    var title: String
    var subtitle: String
}

struct InfoItem: View {
    var model: InfoItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(model.title)
                .font(.custom("Avenir Medium", size: 16))
            Text(model.subtitle)
                .foregroundColor(.secondary)
                .font(.custom("Avenir Medium", size: 15))
            Divider()
        }
    }
}

struct InfoListItem_Previews: PreviewProvider {
    static var previews: some View {
        InfoItem(model: InfoItemModel(title: "Title", subtitle: "Subtitle"))
            .background(Color(asset: .AppBackgroundColor))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
