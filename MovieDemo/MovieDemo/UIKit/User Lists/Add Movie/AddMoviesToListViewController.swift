//
//  AddMoviesToListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class AddMoviesToListViewController: UITableViewController {
    var dataSource: AddMovieToListDataSource!
    var listId: Int
    var recentMovies: [MovieViewModel]
    var service: UserDetailActionsService
    var searchService: MovieSearchService
    
    var addedMovieIds = IndexSet()
    var loadingMovies = IndexSet()
    
    enum DisplayMode {
        case search
        case recent
    }
    var displayMode: DisplayMode = .recent {
        didSet {
            if oldValue != displayMode {
                updateDataSource()
            }
        }
    }
    
    init(recentMovies: [MovieViewModel], service: UserDetailActionsService, searchService: @escaping MovieSearchService, listId: Int) {
        self.recentMovies = recentMovies
        self.service = service
        self.listId = listId
        self.searchService = searchService
        
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK :- Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = AddMovieToListDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, movie in
            self.cellProvider(indexPath: indexPath, movie: movie)
        })
        
        ListMovieCell.register(to: tableView)
        tableView.rowHeight = 150
        tableView.allowsSelection = false
        dataSource.defaultRowAnimation = .fade
                
        setupSearch()
        updateDataSource()
    }
    
    func cellProvider(indexPath: IndexPath, movie: MovieViewModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListMovieCell.reuseIdentifier, for: indexPath) as! ListMovieCell
        
        ListMovieCell.configure(cell: cell, with: movie)
        cell.addHandler = { [unowned self] in
            self.addMovie(movie: movie, from: cell)
        }
        cell.deleteHandler = { [unowned self] in
            self.removeMovie(movie: movie)
        }
        
        if self.addedMovieIds.contains(movie.id) {
            cell.accessoryMode = .checkmark
        } else if self.loadingMovies.contains(movie.id) {
            cell.accessoryMode = .loading
        } else {
            cell.accessoryMode = .add
        }
        
        return cell
    }
    
    func updateDataSource(animated: Bool = true) {
        if displayMode == .recent {
            dataSource.showSectionHeader = true
            dataSource.update(movies: recentMovies, animated: animated)
        } else if displayMode == .search {
            dataSource.showSectionHeader = false
            dataSource.update(movies: searchResults, animated: animated)
        }
    }
    
    //MARK: - Search
    @Published var query: String = ""
    @Published var searchResults: [MovieViewModel] = []
    var cancellables = Set<AnyCancellable>()
    
    func setupSearch() {
        $query
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap { query -> String? in
                if query.isEmpty {
                    return nil
                }
                
                return query
            }
            .flatMap { [unowned self] query in
                self.searchService(query, 1)
            }
            .handleError { print($0) }
            .map { $0.movies.map(MovieViewModel.init) }
            .sink { movies in
                self.dataSource.update(movies: movies, animated: true)
            }
            .store(in: &cancellables)
    }
    

    //MARK: - Actions
    func addMovie(movie: MovieViewModel, from cell: ListMovieCell) {
        Task {
            loadingMovies.insert(movie.id)
            cell.accessoryMode = .loading
            do {
                try await service.addMovie(movieId:movie.id, toList: listId)
                loadingMovies.remove(movie.id)
                addedMovieIds.insert(movie.id)
                cell.accessoryMode = .checkmark
            } catch {
                loadingMovies.remove(movie.id)
                cell.accessoryMode = .add
            }
        }
    }
    
    func removeMovie(movie: MovieViewModel) {
        Task {
            loadingMovies.insert(movie.id)
            do {
                try await service.removeMovie(movieId:movie.id, fromList: listId)
                loadingMovies.remove(movie.id)
                addedMovieIds.remove(movie.id)
            } catch {
                loadingMovies.insert(movie.id)
            }
        }
    }
    
    deinit {
        print("Deinit")
    }
    
}

extension AddMoviesToListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        query = searchController.searchBar.text ?? ""
        displayMode = query.isEmpty ? .recent : .search
    }
    
}
