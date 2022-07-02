//
//  PosterItemModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 02/07/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct PosterItemModel: Hashable {
    var imageURL: URL?
    var title: String
    var subtitle: String?
    var rating: UInt?
}

extension PosterItemModel {
    init(movie: MovieViewModel, showRating: Bool = false) {
        self.imageURL = movie.posterImageURL(size: .w500)
        self.title = movie.title
        if showRating {
            self.rating = movie.percentRating
        } else {
            self.subtitle = movie.releaseDateWithoutYear
        }
    }
    
    init(credit: CastCreditViewModel) {
        self.imageURL = credit.profileImageURL
        self.title = credit.name
        self.subtitle = credit.character
    }
}
