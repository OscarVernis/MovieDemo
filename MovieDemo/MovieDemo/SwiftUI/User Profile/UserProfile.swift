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
        if user.user != nil {
            ZStack(alignment: .top) {
                if let url = user.avatarURL {
                    BlurBackground(url: url)
                }
                if let username = user.username, let url = user.avatarURL {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .center, spacing: 0) {
                            userHeader(url, username)
                                .padding(.bottom, 10)
                            SectionTitle(title: UserString.Favorites.localized,
                                         font: .detailSectionTitle,
                            tapAction: user.favorites.isEmpty ? nil : showFavorites)
                            MoviePosterRow(movies: user.favorites,
                                           tapAction: showDetail(movie:),
                                           emptyMessage: AttributedStringAsset.emptyFavoritesMessage)
                                .padding(.bottom, 10)
                            SectionTitle(title: UserString.Watchlist.localized,
                                         font: .detailSectionTitle,
                                         tapAction: user.watchlist.isEmpty ? nil : showWatchlist)
                            MoviePosterRow(movies: user.watchlist,
                                           tapAction: showDetail(movie:),
                                           emptyMessage: AttributedStringAsset.emptyWatchlistMessage)
                                .padding(.bottom, 10)
                            SectionTitle(title: UserString.Favorites.localized,
                                         font: .detailSectionTitle,
                                         tapAction: user.rated.isEmpty ? nil : showRated)
                            MoviePosterRow(movies: user.rated,
                                           tapAction: showDetail(movie:),
                                           emptyMessage: AttributedStringAsset.emptyRatedMessage)
                                .padding(.bottom, 10)
                        }
                        .padding(.top, 16)
                    }
                }
            }
        } else {
            loading()
        }
    }
    
    fileprivate func userHeader(_ url: URL, _ username: String) -> some View {
        VStack(spacing: 0) {
            RemoteImage(url: url)
                .frame(width: 142, height: 142)
                .clipShape(Circle())
                .padding(.bottom, 17)
            Text(username)
                .font(.detailSectionTitle)
                .padding(.bottom, 30)
            Button {
                coordinator?.logout()
            } label: {
                Label("Logout", systemImage: ImageAsset.person.rawValue)
            }
            .tint(Color(asset: .AppTintColor))
            .buttonStyle(.bordered)
        }
    }
    
    fileprivate func loading() -> some View {
        return Text("Loading...")
            .onAppear {
                refresh()
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

struct BlurBackground: View {
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        ZStack {
            RemoteImage(url: url)
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .clipped()
                .edgesIgnoringSafeArea(.all)
            Rectangle()
                .fill(.clear)
                .background(.thickMaterial)
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var user = UserViewModel(service: JSONUserLoader(filename: "user"),
                                    cache: nil)
    
    static var previews: some View {
            UserProfile(user: user)
                .preferredColorScheme(.dark)
        }
}
