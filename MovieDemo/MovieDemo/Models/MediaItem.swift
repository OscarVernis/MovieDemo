//
//  MediaItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

enum MediaItem: Codable {
    case person(Person)
    case movie(Movie)
    
    enum CodingKeys: CodingKey, CaseIterable {
        case person
        case movie
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(Person.self, forKey: .person) {
            self = MediaItem.person(value)
            return
        }
        
        if let value = try container.decodeIfPresent(Movie.self, forKey: .movie) {
            self = MediaItem.movie(value)
            return
        }
        
        throw DecodingError.valueNotFound(Self.self, DecodingError.Context(codingPath: CodingKeys.allCases, debugDescription: "person/movie not found"))
    }
    
    public func encode(to encoder: Encoder) throws {
    }
}
