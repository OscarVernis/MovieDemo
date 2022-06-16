//
//  RatedMovieList.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct RatedMovieList: View {
    let movies: [MovieViewModel]
    
    var body: some View {
        ZStack {
            VStack() {
                ForEach(movies, id:\.self) { movie in
                    RatedMovieItem(movie: movie)
                        .frame(height: 50)
                }
            }
        }
        .padding([.leading, .trailing], 20)
    }
}

struct RatedMovieList_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")

    static var previews: some View {
        RatedMovieList(movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
