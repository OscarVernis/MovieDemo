//
//  MovieVideosView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieVideosView: View {
    var videos: [MovieVideoViewModel]
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var shadowOpacity: CGFloat {
        colorScheme == .light ? 0.05 : 0
    }
    
    var body: some View {
        List(videos) { video in
            MovieVideoView(movieVideo: video)
                .listRowBackground(Color.clear)
        }
        .shadow(color: .black.opacity(shadowOpacity), radius: 7, x: 0, y: 3)
        .listStyle(.plain)
        .background(Color(asset: .AppBackgroundColor))
    }
    
}

struct MovieVideosView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MovieVideosView(videos: MockData.movieVideos)
                .navigationTitle("Videos")
        }
    }
}
