//
//  MoviePosterList.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MoviePosterList: View {
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
        VStack() {
            if let title = title {
                SectionTitle(title: title, tapAction: titleAction)
            }
            ForEach(movies, id:\.self) { movie in
                MovieListItem(movie: movie)
                    .onTapGesture {
                        tapAction?(movie)
                    }
            }
            .padding([.leading, .trailing], 20)
        }
    }
}

struct MovieList_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")

    static var previews: some View {
        ScrollView {
            MoviePosterList(title: .localized(HomeString.Popular),
                            movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
