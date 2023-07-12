//
//  UserProfile.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    @ObservedObject var store: UserProfileStore
    var user: UserViewModel {
        store.user
    }
    var router: UserProfileRouter?
    
    var body: some View {
        Group {
            if !user.username.isEmpty {
                ZStack(alignment: .center) {
                    if let url = user.avatarURL {
                        BlurBackground(url: url)
                    }
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .center, spacing: 0) {
                            userHeader(user.username, user.avatarURL)
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
            } else {
                ActivityIndicator(shouldAnimate: Binding.constant(true))
            }
        }
        .onAppear {
            refresh()
        }
    }
    
    fileprivate func userHeader( _ username: String, _ url: URL?) -> some View {
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
                router?.logout()
            })
            .padding()
        }
    }
    
    fileprivate func refresh() {
        store.updateUser()
    }
    
    //MARK: - Navigation
    fileprivate func showFavorites() {
        router?.showUserFavorites()
    }
    
    fileprivate func showWatchlist() {
        router?.showUserWatchlist()
    }
    
    fileprivate func showRated() {
        router?.showUserRated()
    }
    
    fileprivate func showDetail(movie: MovieViewModel) {
        router?.showMovieDetail(movie: movie)
    }
    
}

struct UserProfile_Previews: PreviewProvider {    
    static var previews: some View {
        UserProfile(store: MockData.userProfileStore)
            .preferredColorScheme(.dark)
    }
}
