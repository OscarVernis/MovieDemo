//
//  HomeSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class HomeSection {
    enum SectionType: Int, CaseIterable {
        case NowPlaying
        case Popular
        case TopRated
        case Upcoming
        
        func title() -> String {
            switch self {
            case .NowPlaying:
                return "Now Playing"
            case .Popular:
                return "Popular"
            case .TopRated:
                return "Top Rated"
            case .Upcoming:
                return "Upcoming"
            }
        }
    }
    
    var title: String {
        sectionType.title()
    }
    
    var index: Int
    var sectionType: SectionType = .NowPlaying
    var dataProvider: MovieListDataProvider
    
    var didUpdate:((Int) -> Void)!
    
    var movies: [Movie] {
        dataProvider.movies
    }
    
    init(_ type: SectionType, index: Int, didUpdate:  ((Int) -> Void)!) {
        self.sectionType = type
        self.index = index
        self.didUpdate = didUpdate
        
        switch sectionType {
        case .NowPlaying:
            self.dataProvider = MovieListDataProvider(.NowPlaying)
        case .Popular:
            self.dataProvider = MovieListDataProvider(.Popular)
        case .TopRated:
            self.dataProvider = MovieListDataProvider(.TopRated)
        case .Upcoming:
            self.dataProvider = MovieListDataProvider(.Upcoming)
        }
        
        self.dataProvider.didUpdate = { [weak self] error in
            self?.didUpdate?(index)
        }
        
        self.dataProvider.refresh()
    }
    
}
