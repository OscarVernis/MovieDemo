//
//  MovieVideoViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class MovieVideoViewModel: Identifiable {
    enum VideoSite: String {
        case YouTube
        case Vimeo
        case Unknown
        
        func url(key: String) -> URL {
            switch self {
            case .YouTube:
                return URL(string: "https://www.youtube.com/watch?v=\(key)")!
            case .Vimeo:
                return URL(string: "https://vimeo.com/\(key)")!
            case .Unknown:
                return URL(string: "https://www.youtube.com/watch?v=\(key)")!
            }
        }
    }
    
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
    var id: String {
        video.id
    }
    
    var name: String {
        video.name ?? ""
    }
    
    var key: String {
        video.key
    }
    
    var type: String {
        video.type
    }
    
    var publishedDate: String? {
        guard let date = video.publishedDate else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: date)
    }
    
    var trailerURL: URL {
        let videoSite = VideoSite(rawValue: video.site ?? "Unknown")!
        return videoSite.url(key: video.key)
    }
    
    var thumbnailURL: URL {
        let urlString = String(format: youtubeThumbBaseURL, key)
        return URL(string: urlString)!
    }
    
}

//MARK: - Hashable
extension MovieVideoViewModel: Hashable {
    static func == (lhs: MovieVideoViewModel, rhs: MovieVideoViewModel) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
