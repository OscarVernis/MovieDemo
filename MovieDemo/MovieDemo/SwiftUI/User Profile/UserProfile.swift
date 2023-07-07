//
//  UserProfile.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    @ObservedObject var user: UserViewModel
    weak var coordinator: MainCoordinator?
    
    var body: some View {
        Group {
            if user.user != nil {
                ZStack(alignment: .center) {
                    if let url = user.avatarURL {
                        BlurBackground(url: url)
                    }
                    if let username = user.username, let url = user.avatarURL {
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(alignment: .center, spacing: 0) {
                                userHeader(username, url)
                                    .padding(.bottom, 20)
                                SectionTitle(title: UserString.Favorites.localized,
                                             font: .detailSectionTitle,
                                             tapAction: user.favorites.isEmpty ? nil : showFavorites)
                                PosterRow(movies: user.favorites,
                                               tapAction: showDetail(movie:),
                                               emptyMessage: AttributedStringAsset.emptyFavoritesMessage)
                                .padding(.bottom, 10)
                                SectionTitle(title: UserString.Watchlist.localized,
                                             font: .detailSectionTitle,
                                             tapAction: user.watchlist.isEmpty ? nil : showWatchlist)
                                PosterRow(movies: user.watchlist,
                                               tapAction: showDetail(movie:),
                                               emptyMessage: AttributedStringAsset.emptyWatchlistMessage)
                                .padding(.bottom, 10)
                                SectionTitle(title: UserString.Favorites.localized,
                                             font: .detailSectionTitle,
                                             tapAction: user.rated.isEmpty ? nil : showRated)
                                PosterRow(movies: user.rated,
                                               tapAction: showDetail(movie:),
                                               emptyMessage: AttributedStringAsset.emptyRatedMessage)
                                .padding(.bottom, 10)
                            }
                            .padding(.top, 16)
                        }
                    }
                }
            } else {
                ActivityIndicator(shouldAnimate: Binding.constant(true))
            }
        }
        .onAppear {
            refresh()
        }
    }
    
    fileprivate func userHeader( _ username: String, _ url: URL) -> some View {
        VStack(spacing: 0) {
            RemoteImage(url: url)
                .frame(width: 142, height: 142)
                .clipShape(Circle())
                .padding(.bottom, 17)
            Text(username)
                .font(.detailSectionTitle)
                .padding(.bottom, 30)
            RoundedButton(title: "Logout",
                          image: Image(asset: .person),
                          action: {
                coordinator?.logout()
            })
            .padding()
        }
    }
    
    fileprivate func refresh() {
        user.updateUser()
    }
    
    //MARK: - Navigation
    fileprivate func showFavorites() {
        coordinator?.showMovieList(title: .localized(UserString.Favorites), list: .UserFavorites)
    }
    
    fileprivate func showWatchlist() {
        coordinator?.showMovieList(title: .localized(UserString.Watchlist), list: .UserWatchList)
    }
    
    fileprivate func showRated() {
        coordinator?.showMovieList(title: .localized(UserString.Rated), list: .UserRated)
    }
    
    fileprivate func showDetail(movie: MovieViewModel) {
        coordinator?.showMovieDetail(movie: movie)
    }
    
}

struct UserProfile_Previews: PreviewProvider {    
    static var previews: some View {
        UserProfile(user: .preview)
                .preferredColorScheme(.dark)
        }
}
