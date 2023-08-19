//
//  MovieVideosView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieVideosView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject  var viewModel: MovieVideosViewModel
    
    var shadowOpacity: CGFloat {
        colorScheme == .light ? 0.05 : 0
    }
    
    var body: some View {
        List {
            if viewModel.types.count > 1 {
                CategorySelectionView(selected: $viewModel.selectedType, items: viewModel.types)
            }
            
            ForEach(viewModel.selectedVideos) { video in
                MovieVideoView(movieVideo: video)
                    .shadow(color: .black.opacity(shadowOpacity), radius: 7, x: 0, y: 3)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .background(Color(asset: .AppBackgroundColor))
    }
    
}

struct MovieVideosView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MovieVideosView(viewModel: MovieVideosViewModel(videos: MockData.movieVideos))
                .preferredColorScheme(.dark)
                .navigationTitle("Videos")
        }
    }
}
