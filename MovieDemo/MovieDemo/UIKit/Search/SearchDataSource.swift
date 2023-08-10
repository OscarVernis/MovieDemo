//
//  SearchDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class SearchDataSource: ProviderPagingDataSource<SearchProvider, UICollectionViewCell> {
    typealias Model = Any
    var searchProvider: SearchProvider {
        dataProvider
    }
    
    var query: String = "" {
        didSet {
            searchProvider.query = query
        }
    }
    
    init(collectionView: UICollectionView, searchProvider: SearchProvider) {
        super.init(collectionView: collectionView, dataProvider: searchProvider)
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .main:
                return self.mainCell(collectionView: collectionView, for: item, at: indexPath)
            case .loading:
                return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
            }
        })
    }
    
    private func mainCell(collectionView: UICollectionView, for item: AnyHashable, at indexPath: IndexPath) -> UICollectionViewCell {
        let searchItem = item as! SearchProviderResultItem
        switch searchItem {
        case .movie(let movie):
            return collectionView.cell(at: indexPath, model: movie, cellConfigurator: MovieInfoListCell.configure)
        case .person(let person):
            return collectionView.cell(at: indexPath, model: person, cellConfigurator: CreditPhotoListCell.configure)
        }
    }
    
    override func registerViews(collectionView: UICollectionView) {
        MovieInfoListCell.register(to: collectionView)
        CreditPhotoListCell.register(to: collectionView)
        LoadingCell.register(to: collectionView)
    }
    
}
