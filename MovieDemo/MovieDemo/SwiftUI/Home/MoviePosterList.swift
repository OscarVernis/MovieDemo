//
//  MoviePosterList.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MoviePosterList: View {
    let movies: [MovieViewModel]

    var body: some View {
        VStack() {
            ForEach(movies, id:\.self) { movie in
                MovieListItem(movie: movie)
            }
        }
        .padding([.leading, .trailing], 20)
    }
}

struct MovieList_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")

    static var previews: some View {
        ScrollView {
            MoviePosterList(movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
