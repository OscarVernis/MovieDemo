//
//  SocialLink.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 31/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

enum SocialLink: Hashable, Codable {
    case imdb(id: String)
    case facebook(username: String)
    case instagram(username: String)
    case tiktok(username: String)
    case twitter(username: String)
    case youtube(username: String)
    case homepage(url: URL)
    
    var url: URL {
        switch self {
        case .imdb(id: let id):
            return URL(string: "https://www.imdb.com/name/\(id)")!
        case .facebook(username: let username):
            return URL(string: "https://www.facebook.com/\(username)")!
        case .instagram(username: let username):
            return URL(string: "https://www.instagram.com/\(username)")!
        case .tiktok(username: let username):
            return URL(string: "https://www.tiktok.com/@\(username)")!
        case .twitter(username: let username):
            return URL(string: "https://www.twitter.com/\(username)")!
        case .youtube(username: let username):
            return URL(string: "https://www.youtube.com/\(username)")!
        case .homepage(url: let url):
            return url
        }
    }
}
