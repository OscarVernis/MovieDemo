//
//  RatedMovieItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct RatedMovieItem: View {
    let movie: MovieViewModel
    var showsDivider: Bool
    
    init(movie: MovieViewModel, showsDivider: Bool = true) {
        self.movie = movie
        self.showsDivider = showsDivider
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Text(movie.title)
                    .titleStyle()
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                ZStack(alignment: .center) {
                    Rating(progress: movie.percentRating)
                        .frame(width: 32, height: 32)
                    Text(movie.ratingString)
                        .font(.custom("Avenir Next Condensed Bold", size: 15))
                }
            }
            Spacer()
            if showsDivider {
                Divider()
            }
        }
    }
}

struct RatedMovieItem_Previews: PreviewProvider {
    static let movieLoader = JSONMovieDetailsLoader(filename: "movie")

    static var previews: some View {
        RatedMovieItem(movie: MovieViewModel(movie: movieLoader.movie))
            .previewLayout(.fixed(width: 375, height: 50))
            .preferredColorScheme(.dark)
    }
}
