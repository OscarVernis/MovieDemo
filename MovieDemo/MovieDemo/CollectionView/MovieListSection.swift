//
//  MovieListSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieListSection: FectchableSection {
    let title: String
        
    var dataProvider: MovieListDataProvider
    
    var didUpdate: (() -> Void)?
                
    init(title: String = "", dataProvider: MovieListDataProvider) {
        self.title = title
        self.dataProvider = dataProvider
        
        self.dataProvider.didUpdate = { error in
            if error == nil {
                self.didUpdate?()
            }
        }
        
    }
    
    var itemCount: Int {
        return dataProvider.models.count
    }
    
    var isLastPage: Bool {
        return dataProvider.isLastPage
    }
    
    func fetchNextPage() {
        dataProvider.fetchNextPage()
    }
    
    func refresh() {
        dataProvider.refresh()
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        MovieInfoListCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
        let section = sectionBuilder.createListSection()
        section.contentInsets.bottom = 30

        return section
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoListCell.reuseIdentifier, for: indexPath) as! MovieInfoListCell
        let movie = dataProvider.models[indexPath.row]
        
        MovieInfoCellConfigurator().configure(cell: cell, with: movie)
        
        return cell
    }
    
}
