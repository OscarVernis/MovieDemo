//
//  MovieVideoViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class MovieVideoViewModel {
    private var video: MovieVideo
    
    
    init(video: MovieVideo) {
        self.video = video
    }
}

//MARK: - Youtube Utils
extension MovieVideoViewModel {
    private var baseTrailerURL: String {
        return "https://www.youtube.com/watch?v="
    }
    
    private var youtubeThumbBaseURL: String {
        return "https://img.youtube.com/vi/%@/hqdefault.jpg"
    }

}

//MARK: - Properties
extension MovieVideoViewModel {
    var name: String {
        return video.name ?? ""
    }
    
    var key: String {
        return video.key
    }
    
    var type: String {
        return video.type ?? ""
    }
    
    var youtubeURL: URL {
        return URL(string: baseTrailerURL.appending(key))!
    }
    
    var thumbnailURLForYoutubeVideo: URL {
        let urlString = String(format: youtubeThumbBaseURL, key)
        return URL(string: urlString)!
    }
    
}

