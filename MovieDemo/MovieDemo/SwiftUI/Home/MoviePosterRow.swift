//
//  MoviePosterRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MoviePosterRow: View {
    let movies: [MovieViewModel]
    var tapAction: ((MovieViewModel) -> Void)?
    var emptyMessage: NSAttributedString?
    
    init(movies: [MovieViewModel], tapAction: ((MovieViewModel) -> Void)? = nil, emptyMessage: NSAttributedString? = nil) {
        self.movies = movies
        self.tapAction = tapAction
        self.emptyMessage = emptyMessage
    }
    
    var body: some View {
        if let emptyMessage = emptyMessage, movies.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "film")
                    .foregroundColor(Color(uiColor: .secondarySystemFill))
                    .font(.system(size: 145))
                Text(AttributedString(emptyMessage))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(Color(uiColor: .placeholderText))
                    .font(.custom("Avenir Next Regular", size: 17))
            }
            .frame(height: 260)
        } else {
            movieRow()
        }
    }

    fileprivate func movieRow() -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
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
    
}

struct MoviePosterRow_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")

    static var previews: some View {
        MoviePosterRow(movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
            .previewLayout(.fixed(width: 375, height: 500))
            .preferredColorScheme(.dark)
        MoviePosterRow(movies: [],
                       emptyMessage: AttributedStringAsset.emptyRatedMessage)
            .previewLayout(.fixed(width: 375, height: 500))
            .preferredColorScheme(.dark)
    }
}
