//
//  ProviderPagingDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class ProviderPagingDataSource<Provider: DataProvider, Cell: UICollectionViewCell>: UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>, PagingDataSource {
    typealias Model = Provider.Model
    
    enum Section: Int, CaseIterable {
        case main
        case loading
    }
    
    typealias CellConfigurator = (Cell, Provider.Model) -> Void
    
    var dataProvider: Provider
    private let cellConfigurator: CellConfigurator?
    
    var didUpdate: ((Error?) -> ())? = nil
    var isLoading: Bool = false
    private(set) var isRefreshable: Bool = true
    
    let loadingSectionID = UUID().uuidString
    
    init(collectionView: UICollectionView, dataProvider: Provider, cellConfigurator: CellConfigurator?, cellProvider: @escaping UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>.CellProvider) {
        self.dataProvider = dataProvider
        self.cellConfigurator = cellConfigurator

        super.init(collectionView: collectionView, cellProvider: cellProvider)

        registerViews(collectionView: collectionView)
        self.dataProvider.didUpdate = { [weak self] error in
            self?.providerDidUpdate(error: error)
        }
    }
    
    convenience init(collectionView: UICollectionView, dataProvider: Provider, cellConfigurator: @escaping CellConfigurator) {
        self.init(collectionView: collectionView, dataProvider: dataProvider, cellConfigurator: cellConfigurator) { collectionView, indexPath, itemIdentifier in
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .main:
                let model = dataProvider.item(atIndex: indexPath.row)
                return collectionView.cell(at: indexPath, model: model, cellConfigurator: cellConfigurator)
            case .loading:
                return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
            }
            
        }
    }
    
    func registerViews(collectionView: UICollectionView) {
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
    
    func model(at indexPath: IndexPath) -> Model? {
        return itemIdentifier(for: indexPath) as? Model
    }
    
}
