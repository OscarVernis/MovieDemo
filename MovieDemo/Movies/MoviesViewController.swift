//
//  MoviesViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController, UITableViewDataSourcePrefetching, UISearchResultsUpdating, UISearchControllerDelegate {
    @IBOutlet weak var serviceSegmentedControl: UISegmentedControl!
    
    var dataProvider = MoviesDataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        
        tableView.estimatedRowHeight = 0
        tableView.prefetchDataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tableView.refreshControl?.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
        refreshMovies()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        dataProvider.movieService = MovieService(rawValue: sender.selectedSegmentIndex)!
        refreshMovies()
    }
    
    @objc func refreshMovies() {
        dataProvider.refresh {
            if self.tableView.refreshControl?.isRefreshing ?? false {
                self.tableView.refreshControl?.endRefreshing()
            }
            self.tableView.reloadData()
        }
    }
    
    func refreshSearch() {
        let query = navigationItem.searchController?.searchBar.text ?? ""
        if !query.isEmpty {
            dataProvider.searchQuery = query
            refreshMovies()
        }
    }
    
    // MARK: - Table view data source
    
    func isLoadingCell(indexPath: IndexPath) -> Bool {
        return indexPath.row >= dataProvider.movies.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataProvider.currentPage < dataProvider.totalPages {
            return dataProvider.movies.count + 1
        } else {
            return dataProvider.movies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingCell(indexPath: indexPath) {
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = dataProvider.movies[indexPath.row]
            
            cell.movie = movie
            
            return cell
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging && navigationItem.searchController?.searchBar.isFirstResponder ?? false {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detail = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            detail.movie = dataProvider.movies[indexPath.row]
            
            navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoadingCell(indexPath: indexPath) {
            return 58
        } else {
            return 151
        }
    }
    
    // MARK: - Table view prefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            dataProvider.fetchNextPage {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Searching
    
    func didPresentSearchController(_ searchController: UISearchController) {
        dataProvider.movieService = .Searching
        refreshSearch()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        dataProvider.movieService = .NowPlaying
        refreshMovies()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        refreshSearch()
    }

}
