//
//  Movie+ImageUtils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

extension Movie {
    func backdropImageURL(size: MovieDBService.BackdropSize = .w300) -> URL? {
        let url = (backdropPath != nil) ? MovieDBService.backdropImageURL(forPath:backdropPath!, size: size) : nil
        return url
    }
    
    func posterImageURL(size: MovieDBService.MoviePosterSize = .original) -> URL? {
        let url = (posterPath != nil) ? MovieDBService.posterImageURL(forPath:posterPath!, size: size) : nil
        return url
    }
}
