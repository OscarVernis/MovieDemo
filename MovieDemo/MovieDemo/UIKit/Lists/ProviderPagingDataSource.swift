//
//  ProviderPagingDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class ProviderPagingDataSource<Provider: DataProvider, Cell: UICollectionViewCell>: PagingDataSource {
    typealias Model = Provider.Model
    
    enum Section: Int, CaseIterable {
        case main
        case loading
    }
    
    typealias CellConfigurator = (Cell, Provider.Model) -> Void
    
    var dataProvider: Provider
    private var cellConfigurator: CellConfigurator? = nil
    
    var didUpdate: ((Error?) -> ())? = nil
    var isLoading: Bool = false
    private(set) var isRefreshable: Bool = true
    
    let loadingSectionID = UUID().uuidString
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    init(collectionView: UICollectionView, dataProvider: Provider, cellConfigurator: CellConfigurator? = nil) {
        self.dataProvider = dataProvider
        self.cellConfigurator = cellConfigurator
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .main:
                let model = dataProvider.item(atIndex: indexPath.row)
                return collectionView.cell(at: indexPath, model: model, cellConfigurator: cellConfigurator)
            case .loading:
                return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
            }
        })
        
        registerViews(collectionView: collectionView)
        
        self.dataProvider.didUpdate = { [weak self] error in
            self?.providerDidUpdate(error: error)
        }
    }
    
    func registerViews(collectionView: UICollectionView) {
        Cell.register(to: collectionView)
        LoadingCell.register(to: collectionView)
    }
    
    func providerDidUpdate(error: Error?) {
        isLoading = false
        reload()
        
        didUpdate?(error)
    }
    
    func reload(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataProvider.items as! [AnyHashable], toSection: .main)
        if !dataProvider.isLastPage {
            snapshot.appendSections([.loading])
            snapshot.appendItems([loadingSectionID], toSection: .loading)
        }
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func refresh() {
        isLoading = true
        dataProvider.refresh()
    }
    
    func loadMore() {
        isLoading = true
        dataProvider.loadMore()
    }
    
    func model(at indexPath: IndexPath) -> Model? {
        dataSource.itemIdentifier(for: indexPath) as? Model
    }
    
}
