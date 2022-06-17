//
//  MovieBannerRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieBannerRow: View {
    var title: String?
    let movies: [MovieViewModel]
        
    init(title: String? = nil, movies: [MovieViewModel]) {
        self.title = title
        self.movies = movies
    }
    
    var body: some View {
        VStack() {
            if let title = title {
                SectionTitle(title: title)
                    .padding(.top, 10)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(movies, id:\.self) { movie in
                        MovieBannerItem(movie: movie)
                            .frame(width: 300)
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
        .scaledToFit()
    }
}

struct MoviesRow_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")
    
    static var previews: some View {
        MovieBannerRow(title: .localized(HomeString.NowPlaying),
                       movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
        .previewLayout(.device)
        .preferredColorScheme(.dark)
    }
    
}
