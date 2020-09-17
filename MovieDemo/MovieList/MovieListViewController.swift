//
//  MovieListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieListViewController: UITableViewController {
    var dataProvider: MovieListDataProvider!
    var dataSource: MoviesTableViewDataSource?
        
    weak var mainCoordinator: MainCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUp()
        refreshMovies()
    }
    
    fileprivate func setUp() {
        tableView.estimatedRowHeight = 0
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tableView.refreshControl?.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(MovieCell.namedNib(), forCellReuseIdentifier: MovieCell.reuseIdentifier)
                
        self.dataSource = MoviesTableViewDataSource(dataProvider: dataProvider, reuseIdentifier: "MovieCell")
        self.tableView.dataSource = dataSource
        self.tableView.prefetchDataSource = dataSource
        
        dataProvider.completionHandler = refreshHandler
    }
    
    func refreshHandler() {
        if tableView.refreshControl?.isRefreshing ?? false {
            tableView.refreshControl?.endRefreshing()
        }
        
        tableView.reloadData()
    }
    
    @objc func refreshMovies() {
        dataProvider.refresh()
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = dataProvider.movies[indexPath.row]
        
        mainCoordinator.showMovieDetail(movie: movie)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource!.isLoadingCell(indexPath: indexPath) {
            return 58
        } else {
            return 151
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging && navigationItem.searchController?.searchBar.isFirstResponder ?? false {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
    }

}
