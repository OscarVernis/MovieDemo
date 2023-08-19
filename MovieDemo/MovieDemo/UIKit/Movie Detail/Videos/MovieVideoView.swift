//
//  MovieVideoView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieVideoView: View {
    let remoteImageURL: URL?
    let title: String
    let type: String
    let dateString: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RemoteImage(url: remoteImageURL)
                .scaledToFill()
                .frame(width: .infinity, height: 198)
                .clipped()
            Text(title)
                .font(.avenirNextMedium(size: 17))
                .padding(.horizontal, 12)
                .padding(.top, 10)
            HStack(spacing: 0) {
                Text(type)
                if let dateString = dateString {
                    Text(" • ")
                    Text(dateString)
                }
            }
            .font(.avenirNextMedium(size: 15))
            .foregroundColor(.secondaryLabel)
            .padding(.bottom, 6)
            .padding(.horizontal, 12)

            Divider()
//                .padding(.horizontal, 12)
            
            HStack(alignment: .center, spacing: 0) {
//                Spacer()
                Button {

                } label: {
                    HStack(alignment: .center, spacing: 3) {
                        Text("OPEN ON YOUTUBE")
                            .font(.avenirNextCondensedDemiBold(size: 17))
                        Image("youtube")
                            .font(.system(size: 18))
                            .offset(CGSize(width: 0, height: -1))
                    }
                    .tint(.label)
                }
           
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 8)
            
        }
        .background(Color(asset: .SectionBackgroundColor))
        .cornerRadius(12)
        .listRowSeparator(.hidden)
    }
}

extension MovieVideoView {
    init(movieVideo: MovieVideoViewModel) {
        self.remoteImageURL = movieVideo.thumbnailURLForYoutubeVideo
        self.title = movieVideo.name
        self.type = movieVideo.type
        self.dateString = movieVideo.publishedDate
    }
}

struct MovieVideoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MovieVideoView(movieVideo: MockData.movieVideos.first!)
                .padding(20)
        }
        .frame(maxHeight: .infinity)
        .background(Color.init(asset: .AppBackgroundColor))
    }
}
