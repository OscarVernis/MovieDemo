//
//  UserListDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class UserListDetailViewController: UITableViewController {
    let store: UserListDetailStore
    var router: UserListDetailRouter?
    
    var dataSource: UserListDetailDataSource!
    
    var cancellables: Set<AnyCancellable> = []
        
    init(store: UserListDetailStore, router: UserListDetailRouter? = nil) {
        self.store = store
        self.router = router
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = .asset(.AppBackgroundColor)
        tableView.backgroundColor = .asset(.AppBackgroundColor)
        
        let header = UserListHeaderView.instantiateFromNib()
        header?.sizeToFit()
        tableView.tableHeaderView = header
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMovie)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList)),
        ]
        
        setupTableView()
        setupStore()
        update()
    }
    
    func setupTableView() {
        dataSource = UserListDetailDataSource(tableView: tableView) { tableView, indexPath, movieId in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListMovieCell.reuseIdentifier, for: indexPath) as! ListMovieCell
            let movie = self.store.movie(at: indexPath.row)
            ListMovieCell.configure(cell: cell, with: movie)
            return cell
        }
        dataSource.removeMovie = { [weak self] index in
            Task { try await self?.store.removeMovie(at: index) }
        }
        
        ListMovieCell.register(to: tableView)
        tableView.rowHeight = 150
        
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(update), for: .valueChanged)
    }
    
    fileprivate func setupStore() {
        store.$movies
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] movies in
                self.updateDataSource(movies: movies)
                self.setupHeaderView()
            }
            .store(in: &cancellables)
        
        store.$isLoading
            .sink(receiveValue: { isLoading in
                if !isLoading {
                    self.tableView.refreshControl?.endRefreshing()
                }
            })
            .store(in: &cancellables)
        
        store.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self]  error in
                if error != nil {
                    self?.router?.handle(error: .refreshError)
                }
            }
            .store(in: &cancellables)
    }
    
    fileprivate func setupHeaderView() {
        guard let headerView = tableView.tableHeaderView as? UserListHeaderView else { return }
        
        headerView.titleLable.text = store.userList.name
        headerView.descriptionLabel.text = store.userList.description
        headerView.descriptionLabel.isHidden = store.userList.description.isEmpty
        headerView.countLabel.text = "\(store.movies.count)"
        headerView.ratingLabel.text = store.ratingString
        headerView.ratingView.rating = CGFloat(store.percentRating)
        headerView.ratingView.isRatingAvailable = store.percentRating != 0
        
        headerView.sizeToFit()
        tableView.tableHeaderView = headerView
    }
    
    //MARK: - Actions
    func updateDataSource(movies: [MovieViewModel]) {
        let animated = dataSource.snapshot().numberOfItems != 0
        dataSource.updateDataSource(movies: movies, animated: animated)
    }
    
    @objc
    func update() {
        store.update()
    }
    
    @objc
    func addMovie() {
        router?.showAddMovieToList(title: store.userList.name, delegate: self)
    }
    
    @objc
    func clearList() {
        Task {
            do {
                try await store.clearList()
            } catch {
                router?.handle(error: .refreshError)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = store.movie(at: indexPath.row)
        router?.showMovieDetail(movie: movie)
    }
    
}

extension UserListDetailViewController: AddMoviesToListViewControllerDelegate {
    func add(movie: MovieViewModel) async throws {
        try await store.add(movie: movie)
    }
    
    func remove(movie: MovieViewModel) async throws {
//        try await store.removeMovie(at: <#T##Int#>)
    }
    
    func isMovieAdded(movie: MovieViewModel) -> Bool {
        let movie = store.movies.first { $0.id == movie.id }
        return movie != nil
    }
    
    
}
