//
//  DataProviderSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class DataProviderSection<Provider: ArrayDataProvider, Configurator: CellConfigurator>: FetchableSection {
    var dataProvider: Provider
    let cellConfigurator: Configurator
    
    init(dataProvider: Provider, cellConfigurator: Configurator) {
        self.dataProvider = dataProvider
        self.cellConfigurator = cellConfigurator
        
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
        return dataProvider.itemCount
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        Configurator.Cell.register(to: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
        let section = sectionBuilder.createListSection()
        section.contentInsets.bottom = 30
        
        return section
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Configurator.Cell.reuseIdentifier, for: indexPath) as! Configurator.Cell
        let model = dataProvider.item(atIndex: indexPath.row) as! Configurator.Model
        
        cellConfigurator.configure(cell: cell, with: model)
        
        return cell
    }
    
}
