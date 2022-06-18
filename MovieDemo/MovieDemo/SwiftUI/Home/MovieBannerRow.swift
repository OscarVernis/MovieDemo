//
//  MovieBannerRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieBannerRow: View {
    let movies: [MovieViewModel]
    var tapAction: ((MovieViewModel) -> Void)?
        
    init(movies: [MovieViewModel], tapAction: ((MovieViewModel) -> Void)? = nil) {
        self.movies = movies
        self.tapAction = tapAction
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(movies, id:\.self) { movie in
                    MovieBannerItem(movie: movie)
                        .frame(width: 300)
                        .onTapGesture {
                            tapAction?(movie)
                        }
                }
            }
        }
        .scaledToFit()
    }
}

struct MoviesRow_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")
    
    static var previews: some View {
        MovieBannerRow(movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
        .previewLayout(.device)
        .preferredColorScheme(.dark)
    }
    
}
