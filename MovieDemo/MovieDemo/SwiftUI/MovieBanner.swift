//
//  MovieBanner.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieBanner: View {
    let movie: MovieViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: movie.backdropImageURL(size: .w780))
                .resizable()
                .placeholder(Image(asset: .BackdropPlaceholder))
                .scaledToFit()
                .transition(.fade(duration: 0.5))
                .cornerRadius(12)
            HStack {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                    Text(movie.genres(separatedBy: ", "))
                        .font(.subheadline)
                }
                Spacer()
                Rating(progress: movie.percentRating)
                    .frame(width: 25, height: 25, alignment: .trailing)
            }
        }
    }
}

struct MovieBanner_Previews: PreviewProvider {
    static let movieLoader = JSONMovieDetailsLoader(filename: "movie")
    
    static var previews: some View {
        MovieBanner(movie: MovieViewModel(movie: movieLoader.movie))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
