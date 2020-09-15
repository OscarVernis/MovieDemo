//
//  MoviesViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit

class MoviesViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    @IBOutlet weak var serviceSegmentedControl: UISegmentedControl!
    
    var dataProvider = MovieListDataProvider()
    var dataSource: MoviesTableViewDataSource?
    
    var previousMovieService:MovieListDataProvider.Service = .NowPlaying
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUp()
        refreshMovies()
    }
    
    fileprivate func setUp() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        
        tableView.estimatedRowHeight = 0
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tableView.refreshControl?.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
                
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
        
        //Búsqueda
        let query = navigationItem.searchController?.searchBar.text ?? ""
        if(dataProvider.currentService == .Search && query != dataProvider.searchQuery) {
            refreshSearch()
        }
    }
    
    @objc func refreshMovies() {
        dataProvider.refresh()
    }
    
    func refreshSearch() {
        let query = navigationItem.searchController?.searchBar.text ?? ""
        if !query.isEmpty {
            dataProvider.searchQuery = query
        }
    }
    
    // MARK: - Actions

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        dataProvider.currentService = MovieListDataProvider.Service(rawValue: sender.selectedSegmentIndex)!
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detail = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            detail.movie = dataProvider.movies[indexPath.row]
            
            navigationController?.pushViewController(detail, animated: true)
        }
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
    
    // MARK: - Searching
    
    func didPresentSearchController(_ searchController: UISearchController) {
        previousMovieService = dataProvider.currentService
        dataProvider.currentService = .Search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        refreshSearch()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        dataProvider.currentService = previousMovieService
    }

}
