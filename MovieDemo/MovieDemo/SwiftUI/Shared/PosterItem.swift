//
//  PosterItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct PosterItem: View {
    let model: PosterItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RemoteImage(url: model.imageURL)
                .frame(width: 140, height: 210)
                .padding([.leading, .trailing], 0)
                .padding(.bottom, 5)
            Text(model.title)
                .titleStyle()
                .truncationMode(.tail)
                .lineLimit(1)
            if let subtitle = model.subtitle {
                Text(subtitle)
                    .subtitleStyle()
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
            if let rating = model.rating {
                Rating(style: .line, progress: rating, lineWidth: 6)
                    .padding([.top, .bottom], 3)
            }
        }
    }
}

struct Poster_Previews: PreviewProvider {
    static let movie = MockData.movieVM
    
    static var previews: some View {
        HStack {
            PosterItem(model: PosterItemModel(movie: movie, showRating: true))
                .frame(width: 150, height: 270)
            PosterItem(model: PosterItemModel(movie: movie, showRating: false))
                .frame(width: 150, height: 270)
        }
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
        
        HStack {
            PosterItem(model: PosterItemModel(credit: movie.topCast[0]))
                .frame(width: 150, height: 270)
            PosterItem(model: PosterItemModel(credit: movie.topCast[1]))
                .frame(width: 150, height: 270)
        }
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
