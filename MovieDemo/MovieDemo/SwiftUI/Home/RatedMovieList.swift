//
//  RatedMovieList.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct RatedMovieList: View {
    var title: String?
    var movies: [MovieViewModel]
    var tapAction: ((MovieViewModel) -> Void)?
    var titleAction: (() -> Void)?
    
    init(title: String? = nil, movies: [MovieViewModel], tapAction: ((MovieViewModel) -> Void)? = nil, titleAction: (() -> Void)? = nil) {
        self.title = title
        self.movies = movies
        self.tapAction = tapAction
        self.titleAction = titleAction
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(asset: .SectionBackgroundColor))
            VStack(spacing: 0) {
                if let title = title {
                    SectionTitle(title: title, tapAction: titleAction)
                        .padding(.top, 10)
                        .padding(.bottom, 3)
                }
                ForEach(movies, id:\.self) { movie in
                    RatedMovieItem(movie: movie)
                        .padding(.top, 0)
                        .padding([.leading, .trailing], 20)
                        .frame(height: 50)
                        .onTapGesture {
                            tapAction?(movie)
                        }
                }
            }
        }
        .padding([.leading, .trailing], 20)
    }
}

struct RatedMovieList_Previews: PreviewProvider {
    static let movieLoader = JSONMovieLoader(filename: "now_playing")

    static var previews: some View {
        RatedMovieList(title: .localized(HomeString.TopRated), movies: movieLoader.movies.map { MovieViewModel(movie: $0) })
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
