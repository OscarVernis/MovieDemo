//
//  AddMoviesToListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

protocol AddMoviesToListViewControllerDelegate: AnyObject {
    func add(movie: MovieViewModel) async throws
    func remove(movie: MovieViewModel) async throws
    func isMovieAdded(movie: MovieViewModel) -> Bool
}

class AddMoviesToListViewController: UITableViewController {
    typealias SearchService = (String) -> AnyPublisher<[MovieViewModel], Error>
    
    var dataSource: AddMovieToListDataSource!
    var recentMovies: [MovieViewModel]
    var searchService: SearchService
    var movies: [MovieViewModel] {
        if displayMode == .search {
            return searchResults
        } else {
            return recentMovies
        }
    }
    
    var loadingMovies = IndexSet()
    
    weak var delegate: AddMoviesToListViewControllerDelegate!
    
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
    
    init(recentMovies: [MovieViewModel], searchService: @escaping SearchService, delegate: AddMoviesToListViewControllerDelegate) {
        self.recentMovies = recentMovies
        self.searchService = searchService
        self.delegate = delegate
        
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK :- Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSearchBar()
        setupSearchService()
        updateDataSource()
    }
    
    func setupTableView() {
        ListMovieCell.register(to: tableView)
        tableView.rowHeight = 150
        tableView.allowsSelection = false
        
        dataSource = AddMovieToListDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, _ in
            let movie = movies[indexPath.row]
            return self.cellProvider(indexPath: indexPath, movie: movie)
        })
        dataSource.defaultRowAnimation = .fade
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
        
        self.updateCellAccesory(cell: cell, movie: movie)
        
        return cell
    }
    
    func setupSearchBar() {
        let searchBar = UISearchBar()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = doneButton
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
    
    func updateCellAccesory(cell: ListMovieCell, movie: MovieViewModel) {
        if delegate.isMovieAdded(movie: movie) {
            cell.accessoryMode = .checkmark
        } else if loadingMovies.contains(movie.id) {
            cell.accessoryMode = .loading
        } else {
            cell.accessoryMode = .add
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let searchBar = navigationItem.titleView as? UISearchBar else { return }
        
        searchBar.resignFirstResponder()
    }
    
    //MARK: - Search
    @Published var query: String = ""
    var searchResults: [MovieViewModel] = []
    var cancellables = Set<AnyCancellable>()
    
    func setupSearchService() {
        $query
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map() { [unowned self] query in
                self.searchService(query)
            }
            .switchToLatest()
            .handleError { print($0) }
            .sink { [weak self] movies in
                self?.searchResults = movies
                self?.updateDataSource()
            }
            .store(in: &cancellables)
    }
    

    //MARK: - Actions
    @objc
    func close() {
        dismiss(animated: true)
    }
    
    func addMovie(movie: MovieViewModel, from cell: ListMovieCell) {
        Task {
            loadingMovies.insert(movie.id)
            cell.accessoryMode = .loading
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            do {
                try await delegate.add(movie: movie)
                loadingMovies.remove(movie.id)
                cell.accessoryMode = .checkmark
            } catch {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                loadingMovies.remove(movie.id)
                updateCellAccesory(cell: cell, movie: movie)
            }
        }
    }
    
    func removeMovie(movie: MovieViewModel) {
        Task {
            loadingMovies.insert(movie.id)
            do {
                try await delegate.remove(movie: movie)
                loadingMovies.remove(movie.id)
            } catch {
                loadingMovies.insert(movie.id)
            }
        }
    }
    
}

extension AddMoviesToListViewController: UISearchBarDelegate  {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        query = searchText
        displayMode = query.isEmpty ? .recent : .search
    }
        
}
