//
//  MovieDetail.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieDetail: View {
    var router: MovieDetailRouter?

    @ObservedObject var store: MovieDetailStore
    
    var movie: MovieViewModel {
        store.movie
    }
    
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
                    //Cast
                    if !movie.topCast.isEmpty { cast() }
                    //Crew
                    if !movie.topCrew.isEmpty { crew() }
                    //Videos
                    if !movie.videos.isEmpty { videos() }
                    //Recommended
                    if !movie.recommendedMovies.isEmpty { recommended() }
                    //Info
                    if !movie.infoArray.isEmpty { info() }
                }
            }
        }
        .onAppear {
            store.refresh()
        }
        
    }
    
    //MARK: - Header
    fileprivate func movieHeader() -> some View {
        return VStack(spacing: 10) {
            RemoteImage(url: movie.posterImageURL(size: .w500), placeholder: Image(asset: .PosterPlaceholder))
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
            if store.hasUserStates {
                actionButtons()
            }
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
    
    //MARK: - Sections
    fileprivate func cast() -> some View {
        VStack {
            SectionTitle(title: MovieString.Cast.localized, font: .detailSectionTitle, tapAction: showCastList)
            PosterRow(cast: movie.topCast, tapAction: showCastDetail(credit:))
                .padding(.bottom, 20)
        }
    }
    
    fileprivate func crew() -> some View {
        VStack {
            SectionTitle(title: MovieString.Crew.localized, font: .detailSectionTitle, tapAction: showCrewList)
            InfoTable(credits: movie.topCrew, tapAction: showCrewDetail(credit:))
                .padding(.bottom, 20)
        }
    }
    
    fileprivate func videos() -> some View {
        VStack {
            SectionTitle(title: MovieString.Videos.localized, font: .detailSectionTitle)
            VideoRow(videos: movie.videos, tapAction: playVideo(video:))
                .padding(.bottom, 20)
        }
    }
    
    fileprivate func recommended() -> some View {
        VStack {
            SectionTitle(title: MovieString.RecommendedMovies.localized, font: .detailSectionTitle, tapAction: showRecommended)
            PosterRow(movies: movie.recommendedMovies, showRating: true, tapAction: showMovieDetail(movie:))
                .padding(.bottom, 20)
        }
    }
    
    fileprivate func info() -> some View {
        VStack {
            SectionTitle(title: MovieString.Info.localized, font: .detailSectionTitle)
            InfoTable(info: movie.infoArray)
        }
    }
    
    //MARK: - Navigation
    fileprivate func showCastList() {
        router?.showCastCreditList(credits: movie.cast)
    }
    
    fileprivate func showCrewList() {
        router?.showCrewCreditList(credits: movie.crew)
    }
    
    fileprivate func showRecommended() {
        router?.showRecommendedMovies(for: movie.id)
    }
    
    fileprivate func showMovieDetail(movie: MovieViewModel) {
        router?.showMovieDetail(movie: movie)
    }
    
    fileprivate func showCastDetail(credit: CastCreditViewModel) {
        router?.showPersonProfile(credit.person())
    }
    
    fileprivate func showCrewDetail(credit: CrewCreditViewModel) {
        router?.showPersonProfile(credit.person())
    }
    
    func playVideo(video: MovieVideoViewModel) {
        UIApplication.shared.open(video.youtubeURL)
    }
    
    func playTrailer() {
        guard let youtubeURL = movie.trailerURL else { return }
        UIApplication.shared.open(youtubeURL)
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(store: .preview(showUserActions: true))
            .preferredColorScheme(.dark)
    }
}
