//
//  ArrayPagingDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class ArrayPagingDataSource<Model: Hashable, Cell: UICollectionViewCell>: PagingDataSource {
    typealias CellConfigurator = (Cell, Model) -> Void
    
    enum Section: Int, CaseIterable {
        case main
    }

    var didUpdate: ((Error?) -> ())?
    var isLoading: Bool = false
    var isRefreshable: Bool = false
    
    var models: [Model]
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    init(collectionView: UICollectionView, models: [Model], cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let model = models[indexPath.row]
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: cellConfigurator)
        })
        
        registerViews(collectionView: collectionView)
    }
    
    private func registerViews(collectionView: UICollectionView) {
        Cell.register(to: collectionView)
    }
    
    func reload(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func refresh() {
        reload()
        didUpdate?(nil)
    }
    
    func loadMore() {}
    
    func model(at indexPath: IndexPath) -> Model? {
        dataSource.itemIdentifier(for: indexPath) as? Model
    }
    
}
