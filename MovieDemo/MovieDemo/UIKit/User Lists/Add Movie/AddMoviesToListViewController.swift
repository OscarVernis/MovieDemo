//
//  AddMoviesToListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class AddMoviesToListViewController: UITableViewController {
    var dataSource: AddMovieToListDataSource!
    var listId: Int
    var recentMovies: [MovieViewModel]
    var service: UserDetailActionsService
    
    var addedMovieIds = IndexSet()
    var loadingMovies = IndexSet()
    
    init(recentMovies: [MovieViewModel], service: UserDetailActionsService, listId: Int) {
        self.recentMovies = recentMovies
        self.service = service
        self.listId = listId
        
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        dataSource = AddMovieToListDataSource(tableView: tableView, cellProvider: { tableView, indexPath, movie in
            let cell = tableView.dequeueReusableCell(withIdentifier: ListMovieCell.reuseIdentifier, for: indexPath) as! ListMovieCell
            
            ListMovieCell.configure(cell: cell, with: movie)
            cell.addHandler = {
                self.addMovie(movie: movie)
            }
            cell.deleteHandler = {
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
        })
        
        ListMovieCell.register(to: tableView)
        tableView.rowHeight = 150
        
        updateDataSource()
    }
    
    func updateDataSource(animated: Bool = false) {
        dataSource.update(movies: recentMovies, animated: animated)
    }
    
    func reload(movie: MovieViewModel) {
        dataSource.update(movies: recentMovies, reload: movie, animated: false)
    }
        
    func addMovie(movie: MovieViewModel) {
        Task {
            loadingMovies.insert(movie.id)
            reload(movie: movie)
            do {
                try await service.addMovie(movieId:movie.id, toList: listId)
                loadingMovies.remove(movie.id)
                addedMovieIds.insert(movie.id)
            } catch {
                loadingMovies.remove(movie.id)
            }
            reload(movie: movie)
        }
    }
    
    func removeMovie(movie: MovieViewModel) {
        Task {
            loadingMovies.insert(movie.id)
            reload(movie: movie)
            do {
                try await service.removeMovie(movieId:movie.id, fromList: listId)
                loadingMovies.remove(movie.id)
                addedMovieIds.remove(movie.id)
            } catch {
                loadingMovies.insert(movie.id)
            }
            reload(movie: movie)
        }
    }
    
}
