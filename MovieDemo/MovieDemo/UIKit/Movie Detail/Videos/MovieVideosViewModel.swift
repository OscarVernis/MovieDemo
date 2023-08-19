//
//  MovieVideosViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class MovieVideosViewModel: ObservableObject {
    @Published var selectedType: Int = 0
 
    let videos: [MovieVideoViewModel]
    var types: [String]
    
    var selectedVideos: [MovieVideoViewModel] {
        guard selectedType > 0 else { return videos }
        
        let selected = types[selectedType]
        return videos.filter { $0.type == selected }
    }
    
    init(videos: [MovieVideoViewModel]) {
        self.videos = videos
        var types = Array(Set(videos.map(\.type))).sorted()
        
        if types.count > 1 {
            types.insert(MovieString.All.localized, at: 0)
        }
        
        self.types = types
    }
    
}

