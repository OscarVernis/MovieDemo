//
//  UserListDetailDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class UserListDetailDataSource: UITableViewDiffableDataSource<UserListDetailDataSource.Section, MovieViewModel> {
    enum Section {
        case main
    }
    
    @Published private(set) var isLoading = false
    @Published var error: Error? = nil
    
    let store: UserListDetailStore
    var cancellables: Set<AnyCancellable> = []
    
    init(tableView: UITableView, store: UserListDetailStore) {
        self.store = store
        super.init(tableView: tableView) { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListMovieCell.reuseIdentifier, for: indexPath) as! ListMovieCell
            
            ListMovieCell.configure(cell: cell, with: movie)
            
            return cell
        }
        
        ListMovieCell.register(to: tableView)
        tableView.rowHeight = 150
        
        setupStore()
        update()
    }
    
    //MARK: - Setup
    fileprivate func setupStore() {
        store.$userList
            .sink { list in
                self.updateDataSource(movies: list.movies.map(MovieViewModel.init))
            }
            .store(in: &cancellables)
        
        store.$isLoading
            .assign(to: &$isLoading)
        
        store.$error
            .onCompletion { self.error = nil }
            .assign(to: &$error)
    }
    
    fileprivate func updateDataSource(movies: [MovieViewModel], animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: - Actions
    func update() {
        store.update()
    }
    
    func addMovie(movieId: Int) async throws {
        try await store.addMovie(movieId: movieId)
    }
    
    func removeMovie(at index: Int) {
        Task { try await store.removeMovie(at: index) }
    }
    
    func clearList() async throws {
        try await store.clearList()
    }
    
    func movie(at index: Int) -> MovieViewModel {
        MovieViewModel(movie: store.userList.movies[index])
    }
    
    //MARK: - Table View
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {            
            removeMovie(at: indexPath.row)
        }
    }
    
}
