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
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias SupplementaryViewProvider = DataSource.SupplementaryViewProvider

    enum Section: Int, CaseIterable {
        case main
    }

    var didUpdate: ((Error?) -> ())?
    var isLoading: Bool = false
    var isRefreshable: Bool = false
    
    var models: [Model]
    
    var dataSource: DataSource!
    
    init(collectionView: UICollectionView, models: [Model], cellConfigurator: @escaping CellConfigurator, supplementaryViewProvider: SupplementaryViewProvider? = nil) {
        self.models = models
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let model = itemIdentifier as! Model
            return collectionView.cell(at: indexPath, model: model, cellConfigurator: cellConfigurator)
        })
        
        dataSource.supplementaryViewProvider = supplementaryViewProvider
        
        registerViews(collectionView: collectionView)
    }
    
    private func registerViews(collectionView: UICollectionView) {
        Cell.register(to: collectionView)
    }
    
    func reload(animated: Bool = false) {
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
