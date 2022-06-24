//
//  MovieDetail.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieDetail: View {
    @ObservedObject var movie: MovieViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            if let url = movie.posterImageURL(size: .w500) {
                BlurBackground(url: url)
            }
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    movieHeader()
                        .padding(.bottom, 20)
                        .padding([.leading, .trailing], 20)
                    SectionTitle(title: MovieString.RecommendedMovies.localized, font: .detailSectionTitle)
                    MoviePosterRow(movies: movie.recommendedMovies)
                }
            }
        }
        .onAppear {
            movie.refresh()
        }
    }
    
    fileprivate func movieHeader() -> some View {
        return VStack(spacing: 10) {
            RemoteImage(url: movie.posterImageURL(size: .w500))
                .frame(width: 160)
            Text(movie.title)
                .multilineTextAlignment(.center)
                .font(.movieDetailTitle)
            ZStack(alignment: .center) {
                Rating(progress: movie.percentRating, lineWidth: 4)
                Text(movie.ratingString)
                    .allowsTightening(true)
                    .font(.custom("Avenir Next Condensed Bold", size: 20))
                    .padding(.top, 2)
                    .padding(.leading, 1.5)
            }
            .frame(width: 45, height: 45)
            Text(movie.genres())
                .font(.custom("Avenir Medium", size: 16))
                .foregroundColor(.secondary)
            HStack(spacing: 0) {
                Text(movie.releaseYear)
                    .font(.custom("Avenir Medium", size: 16))
                    .foregroundColor(.secondary)
                if let runtime = movie.runtime {
                    Text("  •  \(runtime)")
                        .font(.subtitleFont)
                        .foregroundColor(Color.secondary)
                }
            }
            actionButtons()
            HStack {
                Text(MovieString.Overview.localized)
                    .font(.detailSectionTitle)
                Spacer()
            }
            Text(movie.overview)
                .font(.custom("Avenir Light Oblique", size: 15))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            RoundedButton(title: "Play Trailer",
                          image: Image(asset: .trailer),
                          tintColor: Color.pink,
                          action: playTrailer)
        }
    }
    
    fileprivate func actionButtons() -> some View {
        HStack {
            RoundedButton(title: "Favorite",
                          image: Image(systemName: "heart"),
                          tintColor: Color(asset: .FavoriteColor))
            RoundedButton(title: "Watchlist",
                          image: Image(systemName: "bookmark"),
                          tintColor: Color(asset: .WatchlistColor))
            RoundedButton(title: "Rate",
                          image: Image(systemName: "star"),
                          tintColor: Color(asset: .RatingColor))
        }
    }
    
    //MARK: - Navigation
    func playTrailer() {
        guard let youtubeURL = movie.trailerURL else { return }
        UIApplication.shared.open(youtubeURL)
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static let movieLoader = JSONMovieDetailsLoader(filename: "movie")
    static let movieViewModel = MovieViewModel(movie: Movie(id: 0, title: ""),
                                               service: movieLoader)

    static var previews: some View {
        MovieDetail(movie: movieViewModel)
            .preferredColorScheme(.dark)
            .onAppear { movieViewModel.refresh() }
    }
}