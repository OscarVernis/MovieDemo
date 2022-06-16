//
//  MovieBanner.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieBanner: View {
    let movie: MovieViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: movie.backdropImageURL(size: .w300))
                .scaledToFit()
                .cornerRadius(12)
            Text(movie.title)
                .font(.headline)
            Text(movie.genres(separatedBy: ", "))
                .font(.subheadline)
        }
    }
}

struct MovieBanner_Previews: PreviewProvider {
    static let movieLoader = JSONMovieDetailsLoader(filename: "movie")
    
    static var previews: some View {
        MovieBanner(movie: MovieViewModel(movie: movieLoader.movie))
    }
}
