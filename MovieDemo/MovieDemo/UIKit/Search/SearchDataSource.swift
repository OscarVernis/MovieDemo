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
        super.init(collectionView: collectionView, dataProvider: searchProvider, cellConfigurator: nil) { collectionView, indexPath, item in
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .main:
                return SearchDataSource.mainCell(collectionView: collectionView, for: item, at: indexPath)
            case .loading:
                return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
            }
        }
    }
    
    static func mainCell(collectionView: UICollectionView, for item: AnyHashable, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        switch item {
        case let movie as MovieViewModel:
            let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoListCell.reuseIdentifier, for: indexPath) as! MovieInfoListCell
            MovieInfoListCell.configure(cell: movieCell, with: movie)
            cell = movieCell
        case let person as PersonViewModel:
            let personCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditPhotoListCell.reuseIdentifier, for: indexPath) as! CreditPhotoListCell
            CreditPhotoListCell.configure(cell: personCell, person: person)
            cell = personCell
        default:
            fatalError("Unknown Media Type")
        }
        
        return cell
    }

    
    override func registerViews(collectionView: UICollectionView) {
        MovieInfoListCell.register(to: collectionView)
        CreditPhotoListCell.register(to: collectionView)
        LoadingCell.register(to: collectionView)
    }
    
}
