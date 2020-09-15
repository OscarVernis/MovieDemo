//
//  MovieBannerCellConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

struct MovieBannerCellConfigurator: CollectionViewCellConfigurator {
    typealias Model = Movie
    typealias CellType = MovieBannerCell
    
    func configure(cell: MovieBannerCell, forModel movie: Movie) {
        cell.backgroundColor = .red
        cell.imageView?.image = nil
//        if let posterPath = movie.posterPath {
//            let url = MovieDBService.posterImageURL(forPath: posterPath, size: .w342)
//            cell.imageView?.af_setImage(withURL: url, imageTransition: .crossDissolve(0.3))
//        }
    }
}
