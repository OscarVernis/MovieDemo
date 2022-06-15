//
//  Home.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct Home: View {
    weak var coordinator: MainCoordinator?
    @ObservedObject var nowPlayingProvider = MoviesProvider(.NowPlaying)
    
    var body: some View {
        List {
            ForEach(nowPlayingProvider.items, id: \.self) { movie in
                Text(movie.title)
            }
        }
        .onAppear(perform: refresh)
        .navigationTitle(HomeString.Movies.localized)
    }
    
    func refresh() {
        nowPlayingProvider.refresh()
    }
}

struct Home_Previews: PreviewProvider {
    static let provider = MoviesProvider(.NowPlaying,
                                  movieLoader: JSONMovieLoader(filename: "now_playing"),
                                  cache: nil)
    
    static var previews: some View {
        NavigationView{
            Home(coordinator: nil, nowPlayingProvider: provider)
                .preferredColorScheme(.dark)
        }
    }
}
