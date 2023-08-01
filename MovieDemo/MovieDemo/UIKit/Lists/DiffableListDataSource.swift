//
//  DiffableListDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

protocol PagingDataSource: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable> {
    var didUpdate: ((Error?) -> ())? { get set }
    var isLoading: Bool { get }
    var isRefreshable: Bool { get }
    
    func refresh()
    func loadMore()
}

class ArrayPagingDataSource<Model: Hashable, Cell: UICollectionViewCell>: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>, PagingDataSource {
    typealias CellConfigurator = (Cell, Model) -> Void
    
    enum Section: Int, CaseIterable {
        case main
    }

    var didUpdate: ((Error?) -> ())?
    var isLoading: Bool = false
    var isRefreshable: Bool = false
    
    var models: [Model]
    
    init(collectionView: UICollectionView, models: [Model], cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let model = models[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
            
            cellConfigurator(cell, model)
            
            return cell
        }
        
        registerViews(collectionView: collectionView)
    }
    
    private func registerViews(collectionView: UICollectionView) {
        Cell.register(to: collectionView)
    }
    
    func reload(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(models, toSection: Section.main)
        apply(snapshot, animatingDifferences: animated)
    }
    
    func refresh() {
        reload()
        didUpdate?(nil)
    }
    
    func loadMore() {}
    
}

class ProviderPagingDataSource<Provider: DataProvider, Cell: UICollectionViewCell>: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>, PagingDataSource {
    enum Section: Int, CaseIterable {
        case main
        case loading
    }
    
    typealias CellConfigurator = (Cell, Provider.Model) -> Void
    
    var dataProvider: Provider
    private let cellConfigurator: CellConfigurator
    
    var didUpdate: ((Error?) -> ())? = nil
    var isLoading: Bool = false
    private(set) var isRefreshable: Bool = true
    
    let loadingSectionID = UUID().uuidString
    
    init(collectionView: UICollectionView, dataProvider: Provider, cellConfigurator: @escaping CellConfigurator) {
        self.dataProvider = dataProvider
        self.cellConfigurator = cellConfigurator
        
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .main:
                let model = dataProvider.item(atIndex: indexPath.row)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
                
                cellConfigurator(cell, model)
                
                return cell
            case .loading:
                return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
            }
           
        }
        
        registerViews(collectionView: collectionView)
        self.dataProvider.didUpdate = { [weak self] error in
            self?.providerDidUpdate(error: error)
        }
    }
    
    private func registerViews(collectionView: UICollectionView) {
        Cell.register(to: collectionView)
        LoadingCell.register(to: collectionView)
    }
    
    private func providerDidUpdate(error: Error?) {
        isLoading = false
        reload()
        
        didUpdate?(error)
    }
    
    func reload(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(dataProvider.items as! [AnyHashable], toSection: Section.main)
        if !dataProvider.isLastPage {
            snapshot.appendSections([Section.loading])
            snapshot.appendItems([loadingSectionID], toSection: Section.loading)
        }
        apply(snapshot, animatingDifferences: animated)
    }
    
    func refresh() {
        isLoading = true
        dataProvider.refresh()
    }
    
    func loadMore() {
        isLoading = true
        dataProvider.loadMore()
    }
}
