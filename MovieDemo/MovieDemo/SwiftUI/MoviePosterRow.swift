//
//  MoviePosterRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI
import Loaf

struct MoviePosterRow: View {
    let movies: [MovieViewModel]

    var body: some View {
        VStack {
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 20) {
                        ForEach(movies, id:\.self) { movie in
                            MoviePoster(movie: movie)
                        }
                    }
                    .frame(height: 260)
                    .padding([.leading, .trailing], 20)
                }
            }
        }
        .scaledToFit()
    }
}

struct MoviePosterRow_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")

    static var previews: some View {
        MoviePosterRow(movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
            .previewLayout(.fixed(width: 375, height: 500))
            .preferredColorScheme(.dark)
    }
}
