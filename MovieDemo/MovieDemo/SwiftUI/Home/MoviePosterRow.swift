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
    var title: String?
    let movies: [MovieViewModel]
    var tapAction: ((MovieViewModel) -> Void)?
    var titleAction: (() -> Void)?
    
    init(title: String? = nil, movies: [MovieViewModel], tapAction: ((MovieViewModel) -> Void)? = nil, titleAction: (() -> Void)? = nil) {
        self.title = title
        self.movies = movies
        self.tapAction = tapAction
        self.titleAction = titleAction
    }

    var body: some View {
        VStack {
            if let title = title {
                SectionTitle(title: title, tapAction: titleAction)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 20) {
                    ForEach(movies, id:\.self) { movie in
                        MoviePosterItem(movie: movie)
                            .frame(width: 140)
                            .onTapGesture {
                                tapAction?(movie)
                            }
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
        .scaledToFit()
    }
}

struct MoviePosterRow_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")

    static var previews: some View {
        MoviePosterRow(title: .localized(HomeString.Upcoming),
            movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
            .previewLayout(.fixed(width: 375, height: 500))
            .preferredColorScheme(.dark)
    }
}
