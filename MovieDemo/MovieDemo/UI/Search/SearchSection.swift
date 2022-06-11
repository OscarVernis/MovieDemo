//
//  SearchSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class SearchSection: FetchableSection {
    var dataProvider = SearchDataProvider()
    
    init() {
        self.dataProvider.didUpdate = { [weak self] error in
            self?.didUpdate?(error)
        }
    }
    
    var isLastPage: Bool {
        return dataProvider.isLastPage
    }
    
    var didUpdate: ((Error?) -> Void)?
    
    func refresh() {
        dataProvider.refresh()
    }
    
    func loadMore() {
        dataProvider.loadMore()
    }
    
    var itemCount: Int {
        dataProvider.itemCount
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        MovieInfoListCell.register(to: collectionView)
        CreditPhotoListCell.register(to: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
        let section = sectionBuilder.createListSection()
        section.contentInsets.bottom = 30
        
        return section
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataProvider.item(atIndex: indexPath.row)
        let cell: UICollectionViewCell
        
        switch item {
        case let movie as MovieViewModel:
            let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoListCell.reuseIdentifier, for: indexPath) as! MovieInfoListCell
            MovieInfoCellConfigurator().configure(cell: movieCell, with: movie)
            cell = movieCell
        case let person as PersonViewModel:
            let personCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditPhotoListCell.reuseIdentifier, for: indexPath) as! CreditPhotoListCell
            PersonCreditPhotoListConfigurator().configure(cell: personCell, person: person)
            cell = personCell
        default:
            fatalError("Unknown Media Type")
        }
        
        return cell
    }
    
}
