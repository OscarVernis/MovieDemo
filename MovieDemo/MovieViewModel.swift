//
//  MovieViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct MovieViewModel {
    let movie: Movie
    
    var title: String {
        return movie.title ?? ""
    }
    
    var overview: String {
        return movie.overview ?? ""
    }
    
    var isRatingAvailable: Bool {
        return !(movie.voteCount == nil || movie.voteCount == 0 || movie.voteAverage == nil)
    }
    
    var rating: Float {
        return movie.voteAverage ?? 0
    }
    
    var genresString: String {
        let genres = movie.genres?.map { $0.string() } ?? []
        let genresString = genres.joined(separator: ", ")
        
        return genresString
    }
    
    var releaseYear: String {
        let dateFormatter = DateFormatter(withFormat: "yyyy", locale: "en_US")
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : ""
    }
    
    var releaseDateWithoutYear: String {
        let dateFormatter = DateFormatter(withFormat: "MMM dd", locale: "en_US")
        return movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : ""
    }
    
    func backdropImageURL(size: MovieDBService.BackdropSize = .w300) -> URL? {
        let url = (movie.backdropPath != nil) ? MovieDBService.backdropImageURL(forPath:movie.backdropPath!, size: size) : nil
        return url
    }
    
    func posterImageURL(size: MovieDBService.MoviePosterSize = .original) -> URL? {
        let url = (movie.posterPath != nil) ? MovieDBService.posterImageURL(forPath:movie.posterPath!, size: size) : nil
        return url
    }
    
}
