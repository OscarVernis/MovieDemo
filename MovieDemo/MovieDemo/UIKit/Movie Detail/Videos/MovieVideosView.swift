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
    
    var body: some View {
        List(videos) { video in
            MovieVideoView(movieVideo: video)
                .listRowBackground(Color.clear)
        }
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
