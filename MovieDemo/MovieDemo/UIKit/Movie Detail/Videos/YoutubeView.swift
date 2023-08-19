//
//  YoutubeView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct YoutubeView: UIViewRepresentable {
    @Binding var youtubeURL: URL?
    @Binding var previewImageURL: URL?

    func makeUIView(context: Context) -> UIYoutubeView {
        UIYoutubeView()
    }

    func updateUIView(_ uiView: UIYoutubeView, context: Context) {
        uiView.previewImageURL = previewImageURL
        uiView.youtubeURL = youtubeURL
    }
}

struct YoutubeView_Previews: PreviewProvider {
    static var youtubeURL = URL(string: "https://www.youtube.com/watch?v=Way9Dexny3w")!
    static var previewImageURL = URL(string: "https://i.ytimg.com/vi/Way9Dexny3w/hqdefault.jpg")!
    
    static var previews: some View {
        YoutubeView(youtubeURL: .constant(youtubeURL),
                    previewImageURL: .constant(previewImageURL))
        .frame(height: 300)
    }
}
