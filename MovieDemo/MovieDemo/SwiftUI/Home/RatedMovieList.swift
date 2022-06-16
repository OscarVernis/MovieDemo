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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(asset: .SectionBackgroundColor))
            VStack() {
                if let title = title {
                    SectionTitle(title: title)
                        .padding(.top, 10)
                }
                ForEach(movies, id:\.self) { movie in
                    RatedMovieItem(movie: movie)
                        .frame(height: 50)
                        .padding([.leading, .trailing], 20)
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
