//
//  MovieListItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieListItem: View {
    let movie: MovieViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 16) {
                WebImage(url: movie.posterImageURL(size: .w500))
                    .placeholder(Image(asset: .PosterPlaceholder))
                    .resizable()
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .cornerRadius(12)
                VStack(alignment: .leading, spacing: 0) {
                    Text(movie.title)
                        .titleStyle()
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(.bottom, 4)
                    Rating(style: .line, progress: movie.percentRating, lineWidth: 6)
                        .frame(width: 150)
                        .padding(.bottom, 8)
                    Text(movie.overview)
                        .descriptionStyle()
                        .truncationMode(.tail)
                        .lineLimit(2)
                        .padding(.bottom, 6)
                    Text(movie.genres())
                        .subtitleStyle()
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(.bottom, 1)
                    Text(movie.releaseYear)
                        .subtitleStyle()
                }
            }
            Divider()
        }
        .padding([.top, .bottom], 2)
        .frame(height: 150)
    }
}

struct MoviePosterListItem_Previews: PreviewProvider {
    static let movieLoader = JSONMovieDetailsLoader(filename: "movie")
    
    static var previews: some View {
        MovieListItem(movie: MovieViewModel(movie: movieLoader.movie))
            .previewLayout(.fixed(width: 375, height: 150))
            .preferredColorScheme(.dark)
    }
}
