//
//  RoundedButton.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct RoundedButton: View {
    var title: String
    var image: Image
    var tintColor = Color(asset: .AppTintColor)
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack(alignment: .center, spacing: 4) {
                image
                Text(title)
                    .font(.custom("Avenir Next Medium ", size: 17))
            }
        }
        .frame(maxWidth: .infinity)
        .tint(tintColor)
        .frame(height: 44)
        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(tintColor.opacity(0.1)))
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HStack {
                RoundedButton(title: "Favorite",
                              image: Image(systemName: "heart"),
                              tintColor: Color(asset: .FavoriteColor))
                RoundedButton(title: "Watchlist",
                              image: Image(systemName: "bookmark"),
                              tintColor: Color(asset: .WatchlistColor))
                RoundedButton(title: "Rate",
                              image: Image(systemName: "star"),
                              tintColor: Color(asset: .RatingColor))
            }
            RoundedButton(title: "Play Trailer",
                          image: .init(asset: .trailer),
                          tintColor: .pink)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(asset: .AppBackgroundColor))
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
}
