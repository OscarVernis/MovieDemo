//
//  MoviesRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieRow: View {
    let movies: [MovieViewModel]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(movies, id:\.self) { movie in
                        MovieBanner(movie: movie)
                    }
                }
            }
        }
    }
}

struct MoviesRow_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")
    
    static var previews: some View {
        MovieRow(movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
    }
}
