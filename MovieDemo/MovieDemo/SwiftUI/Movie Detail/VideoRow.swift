//
//  VideoRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct VideoRow: View {
    let videos: [MovieVideoViewModel]
    var tapAction: ((MovieVideoViewModel) -> Void)?
        
    init(videos: [MovieVideoViewModel], tapAction: ((MovieVideoViewModel) -> Void)? = nil) {
        self.videos = videos
        self.tapAction = tapAction
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(videos, id:\.self) { video in
                    VideoItem(video: video)
                        .frame(width: 300)
                        .onTapGesture {
                            tapAction?(video)
                        }
                }
            }
            .padding([.leading, .trailing], 20)
        }
    }
}

struct VideoRow_Previews: PreviewProvider {
    static let movie: MovieViewModel = MockData.movieVM

    static var previews: some View {
        VideoRow(videos: movie.videos)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
    
}

