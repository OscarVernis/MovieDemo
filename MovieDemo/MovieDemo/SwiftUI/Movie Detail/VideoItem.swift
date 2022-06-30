//
//  VideoItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

import SwiftUI

struct VideoItem: View {
    let video: MovieVideoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                RemoteImage(url: video.thumbnailURLForYoutubeVideo,
                            placeholder: Image(asset: .BackdropPlaceholder))
                .frame(width: 300, height: 225)
                .padding(.bottom, 5)
                Image(systemName: "play.rectangle.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 100))
                    .frame(width: 117)
            }
            Text(video.type)
                .foregroundColor(.secondary)
                .font(.custom("Avenir Next Medium", size: 17))
                .lineLimit(1)
        }
    }
}

struct VideoItem_Previews: PreviewProvider {
    static let movie = JSONMovieDetailsLoader(filename: "movie").viewModel
    
    static var previews: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(movie.videos, id: \.self) { video in
                    VideoItem(video: video)
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                }
            }
        }
        .background(Color(asset: .AppBackgroundColor))
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
