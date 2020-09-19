//
//  HomeCollectionViewDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

//MARK: - CollectionView DataSource
class HomeCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let sections: [HomeSection]
    
    var sectionHeaderButtonHandler: ((HomeSection) -> Void)?
    
    init(sections: [HomeSection]) {
        self.sections = sections
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxTopRated = 10
        
        let s = sections[section]
        if s.sectionType == .TopRated, s.movies.count >= maxTopRated {
            return maxTopRated
        } else {
            return s.movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as? SectionTitleView  else { fatalError() }
        
        let section = sections[indexPath.section]
        let tapHandler: (() -> ())? = { [weak self] in
            self?.sectionHeaderButtonHandler?(section)
        }
        
        HomeTitleSectionConfigurator().configure(headerView: sectionTitleView, title: section.title, tapHandler: tapHandler)
        
        return sectionTitleView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let movie = section.movies[indexPath.row]
        
        var cell: UICollectionViewCell!
        switch section.sectionType {
        case .NowPlaying:
            guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieBannerCell.reuseIdentifier, for: indexPath) as? MovieBannerCell else { fatalError() }
            
            bannerCell.configure(withMovie: MovieViewModel(movie: movie))
            cell = bannerCell
        case .Upcoming:
            guard let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as? MoviePosterInfoCell else { fatalError() }
            
            MoviePosterTitleDateCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: movie))
            cell = posterCell
        case .TopRated:
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieRatingListCell.reuseIdentifier, for: indexPath) as? MovieRatingListCell else { fatalError() }
            
            let isLastCell = indexPath.row == 9 //dataProvider.movies.count - 1
            listCell.configure(withMovie: MovieViewModel(movie: movie), showSeparator: !isLastCell)
            cell = listCell
        case .Popular:
            guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoListCell.reuseIdentifier, for: indexPath) as? MovieInfoListCell else { fatalError() }
            
            MovieInfoCellConfigurator().configure(cell: infoCell, with: movie)
            cell = infoCell
        }
        
        return cell
    }
    
}
