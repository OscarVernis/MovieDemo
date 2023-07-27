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
                print(movie.title)
                cell.accessoryMode = .checkmark
            }
            cell.deleteHandler = {
                cell.accessoryMode = .loading
            }
            cell.accessoryMode = .add
            
            return cell
        })
        
        ListMovieCell.register(to: tableView)
        tableView.rowHeight = 150
        
        dataSource.update(movies: recentMovies, animated: false)
    }
    
    func addMovie(movie: MovieViewModel) {
        Task { try await service.addMovie(movieId:movie.id, toList: listId) }
    }
    
}
