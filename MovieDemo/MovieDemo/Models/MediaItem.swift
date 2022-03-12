//
//  MediaItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

enum MediaItem {
    case person(Person)
    case movie(Movie)
    case unknown
}
    
extension MediaItem: Codable, Equatable {
    enum CodingKeys: String, CodingKey, CaseIterable {
        case mediaType = "media_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decodeIfPresent(String.self, forKey: .mediaType)
                
        if type == "person", let person = try? Person(from: decoder) {
            self = MediaItem.person(person)
            return
        }

        if type == "movie", let movie = try? Movie(from: decoder) {
            self = MediaItem.movie(movie)
            return
        }

        self = .unknown
    }
    
    func encode(to encoder: Encoder) throws {  }

}
