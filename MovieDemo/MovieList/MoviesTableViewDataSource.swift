//
//  PagingTableViewDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class MoviesTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    var dataProvider: MovieListDataProvider
    lazy var cellConfigurator = MovieCellConfigurator()
    
    private let reuseIdentifier: String
    
    init(dataProvider: MovieListDataProvider, reuseIdentifier: String) {
        self.dataProvider = dataProvider
        self.reuseIdentifier = reuseIdentifier
    }
    
    func isLoadingCell(indexPath: IndexPath) -> Bool {
        return indexPath.row >= dataProvider.movies.count
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataProvider.currentPage < dataProvider.totalPages {
            return dataProvider.movies.count + 1
        } else {
            return dataProvider.movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingCell(indexPath: indexPath) {
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = dataProvider.movies[indexPath.row]
            
            cellConfigurator.configure(cell: cell, withMovie: MovieViewModel(movie: movie))
            
            return cell
        }
    }
    
    // MARK: - Table view prefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            dataProvider.fetchNextPage()
        }
    }
}

