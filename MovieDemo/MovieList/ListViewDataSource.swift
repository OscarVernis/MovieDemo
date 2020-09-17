//
//  ListViewDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class ListViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    var dataProvider: MovieListDataProvider
    
    private let reuseIdentifier: String
    
    init(dataProvider: MovieListDataProvider, reuseIdentifier: String) {
        self.dataProvider = dataProvider
        self.reuseIdentifier = reuseIdentifier
    }
    
    func isLoadingCell(indexPath: IndexPath) -> Bool {
        return indexPath.row >= dataProvider.movies.count
    }
}
    
    // MARK: - CollectionView data source
extension ListViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataProvider.currentPage < dataProvider.totalPages {
            return dataProvider.movies.count + 1
        } else {
            return dataProvider.movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoadingCell(indexPath: indexPath) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCell.reuseIdentifier, for: indexPath) as! MovieInfoCell
            let movie = dataProvider.movies[indexPath.row]
            
            MovieInfoCellDecorator().configure(cell: cell, withMovie: MovieViewModel(movie: movie))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            dataProvider.fetchNextPage()
        }
    }
    
}
