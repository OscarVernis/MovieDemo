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
        sectionTitleView.titleLabel.text = section.title
        sectionTitleView.tapHandler = {
            self.sectionHeaderButtonHandler?(section)
        }
        
        return sectionTitleView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let movie = section.movies[indexPath.row]
        
        var cell: UICollectionViewCell!
        switch section.index {
        case 0:
            guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieImageCell.reuseIdentifier, for: indexPath) as? MovieImageCell else { fatalError() }
            
            bannerCell.configureBackdrop(withMovie: movie)
            cell = bannerCell
        case 1:
            guard let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieImageCell.reuseIdentifier, for: indexPath) as? MovieImageCell else { fatalError() }
            
            bannerCell.configurePoster(withMovie: movie)
            cell = bannerCell
        case 2:
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCell.reuseIdentifier, for: indexPath) as? MovieListCell else { fatalError() }
            
            let isLastCell = indexPath.row == 9 //dataProvider.movies.count - 1
            listCell.configure(withMovie: movie, showSeparator: !isLastCell)
            cell = listCell
        case 3:
            guard let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCell.reuseIdentifier, for: indexPath) as? MovieInfoCell else { fatalError() }
            
            infoCell.configure(withMovie: movie)
            cell = infoCell
        default:
            fatalError()
        }
        
        return cell
    }
    
}
