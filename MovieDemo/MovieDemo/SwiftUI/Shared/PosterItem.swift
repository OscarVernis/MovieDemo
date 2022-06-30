//
//  PosterItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct PosterItemModel: Hashable {
    var imageURL: URL?
    var title: String
    var subtitle: String?
    var rating: UInt?
    
    init(movie: MovieViewModel, showRating: Bool = false) {
        self.imageURL = movie.posterImageURL(size: .w500)
        self.title = movie.title
        if showRating {
            self.rating = movie.percentRating
        } else {
            self.subtitle = movie.releaseDateWithoutYear
        }
    }
    
    init(credit: CastCreditViewModel) {
        self.imageURL = credit.profileImageURL
        self.title = credit.name
        self.subtitle = credit.character
    }
}

struct PosterItem: View {
    let model: PosterItemModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RemoteImage(url: model.imageURL,
                        placeholder: Image(asset: .PosterPlaceholder))
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
    static let movie = MovieViewModel(movie: JSONMovieDetailsLoader(filename: "movie").movie)
    
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
