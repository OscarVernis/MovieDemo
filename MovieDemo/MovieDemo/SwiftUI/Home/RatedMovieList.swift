//
//  RatedMovieList.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct RatedMovieList: View {
    var movies: [MovieViewModel]
    var tapAction: ((MovieViewModel) -> Void)?
    
    init(movies: [MovieViewModel], tapAction: ((MovieViewModel) -> Void)? = nil) {
          self.movies = movies
          self.tapAction = tapAction
      }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(movies, id:\.self) { movie in
                RatedMovieItem(movie: movie, showsDivider: movie != movies.last)
                    .padding(.top, 0)
                    .frame(height: 50)
                    .onTapGesture {
                        tapAction?(movie)
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
