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
    var showRating: Bool
    var showDate: Bool
    
    init(movie: MovieViewModel, showRating: Bool = false, showDate: Bool = true) {
        self.movie = movie
        self.showRating = showRating
        self.showDate = showDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RemoteImage(url: movie.posterImageURL(size: .w500),
                        placeholder: Image(asset: .PosterPlaceholder))
                .frame(width: 140, height: 210)
                .padding([.leading, .trailing], 0)
                .padding(.bottom, 5)
            Text(movie.title)
                .titleStyle()
                .truncationMode(.tail)
                .lineLimit(1)
            if showDate {
                Text(movie.releaseDateWithoutYear)
                    .subtitleStyle()
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
            if showRating {
                Rating(style: .line, progress: movie.percentRating, lineWidth: 6)
                    .padding(.bottom, 3)
            }
        }
    }
}

struct MoviePoster_Previews: PreviewProvider {
    static let movieLoader = JSONMovieDetailsLoader(filename: "movie")
    
    static var previews: some View {
        MoviePosterItem(movie: MovieViewModel(movie: movieLoader.movie),
                        showRating: true,
                        showDate: true)
        .frame(width: 150, height: 270)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
