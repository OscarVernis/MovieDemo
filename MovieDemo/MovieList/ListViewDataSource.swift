//
//  ListViewDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

open class ListViewDataSource<Provider: ArrayDataProvider>: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    var dataProvider: Provider
    
    private let reuseIdentifier: String
    
    init(dataProvider: Provider, reuseIdentifier: String) {
        self.dataProvider = dataProvider
        self.reuseIdentifier = reuseIdentifier
    }
    
    func isLoadingCell(indexPath: IndexPath) -> Bool {
        return indexPath.row >= dataProvider.models.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataProvider.currentPage < dataProvider.totalPages {
            return dataProvider.models.count + 1
        } else {
            return dataProvider.models.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoadingCell(indexPath: indexPath) {
            return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoCell.reuseIdentifier, for: indexPath) as! MovieInfoCell
            let movie = dataProvider.models[indexPath.row]
            
            MovieInfoCellDecorator().configure(cell: cell, withMovie: MovieViewModel(movie: movie as! Movie))
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            dataProvider.fetchNextPage()
        }
    }
    
}
