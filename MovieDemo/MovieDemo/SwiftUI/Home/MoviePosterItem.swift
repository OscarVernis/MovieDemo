//
//  MoviePosterItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MoviePosterItem: View {
    let movie: MovieViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            WebImage(url: movie.posterImageURL(size: .w500))
                .placeholder(Image(asset: .PosterPlaceholder))
                .resizable()
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .cornerRadius(12)
                .layoutPriority(2)
//            Text("==============")
//                .truncationMode(.tail)
//                .lineLimit(1)
            Text(movie.title)
                .truncationMode(.tail)
                .lineLimit(1)
                .foregroundColor(.label)
                .font(.titleFont)
            Text(movie.releaseDateWithoutYear)
                .truncationMode(.tail)
                .lineLimit(1)
                .foregroundColor(.secondaryLabel)
                .font(.subtitleFont)
        }
    }
}

struct MoviePoster_Previews: PreviewProvider {
    static let movieLoader = JSONMovieDetailsLoader(filename: "movie")

    static var previews: some View {
        MoviePosterItem(movie: MovieViewModel(movie: movieLoader.movie))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
