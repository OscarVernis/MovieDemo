//
//  MoviesViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit

enum MovieService: Int {
    case NowPlaying = 0, Popular, TopRated, Upcoming, Searching
}

class MoviesViewController: UITableViewController, UITableViewDataSourcePrefetching, UISearchResultsUpdating, UISearchControllerDelegate {
    @IBOutlet weak var serviceSegmentedControl: UISegmentedControl!
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var movieService = MovieService.NowPlaying {
        didSet {
            refreshMovies()
        }
    }
    
    var isFetching = false
    var currentPage = 1
    var totalPages = 1

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
        
        fetchMovies()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        movieService = MovieService(rawValue: sender.selectedSegmentIndex)!
    }
    
    @objc func refreshMovies() {
        currentPage = 1
        fetchMovies()
    }
    
    func refreshSearch() {
        currentPage = 1
        let query = navigationItem.searchController?.searchBar.text ?? ""
        if !query.isEmpty {
            fetchMovies()
        }
    }
    
    func fetchMovies() {
        if isFetching {
            return
        }
        
        isFetching = true
        
        let fetchHandler: ([Movie], Int, Error?) -> () = { [weak self] movies, totalPages, error in
            guard let self = self else { return }
            
            self.isFetching = false
            
            if let error = error {
                print(error)
                return
            }
            
            if self.currentPage == 1 {
                self.movies.removeAll()
            }
            
            self.totalPages = totalPages
            self.currentPage += 1
            
            self.movies.append(contentsOf: movies)
            
            if self.tableView.refreshControl?.isRefreshing ?? false {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
        
        switch movieService {
        case .NowPlaying:
            Movie.fetchNowPlaying(page: currentPage, completion: fetchHandler)
        case .Popular:
            Movie.fetchPopular(page: currentPage, completion: fetchHandler)
        case .TopRated:
            Movie.fetchTopRated(page: currentPage, completion: fetchHandler)
        case .Upcoming:
            Movie.fetchUpcoming(page: currentPage, completion: fetchHandler)
        case .Searching:
            let query = navigationItem.searchController?.searchBar.text ?? ""
            Movie.search(query: query, page: currentPage, completion: fetchHandler)
        }
    }

    // MARK: - Table view data source
    
    func isLoadingCell(indexPath: IndexPath) -> Bool {
        return indexPath.row >= movies.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentPage < totalPages {
            return movies.count + 1
        } else {
            return movies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingCell(indexPath: indexPath) {
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = movies[indexPath.row]
            
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
            detail.movie = movies[indexPath.row]
            
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
            fetchMovies()
        }
    }
    
    // MARK: - Searching
    
    func didPresentSearchController(_ searchController: UISearchController) {
        currentPage = 1
        movieService = .Searching

    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        currentPage = 1
        movieService = .NowPlaying
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        refreshSearch()
    }

}
