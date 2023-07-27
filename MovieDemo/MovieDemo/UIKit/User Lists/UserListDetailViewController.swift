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
    var dataSource: UserListDetailDataSource?
    var dataSourceProvider: (UITableView) -> UserListDetailDataSource
    var router: UserListDetailRouter?
    
    var cancellables = Set<AnyCancellable>()
    
    init(dataSourceProvider: @escaping (UITableView) -> UserListDetailDataSource, router: UserListDetailRouter? = nil) {
        self.dataSourceProvider = dataSourceProvider
        self.router = router
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMovie)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList)),
        ]
        
        setup()
    }
    
    func setup() {
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateListDetail), for: .valueChanged)
        
        dataSource = dataSourceProvider(tableView)
        
        dataSource?.$isLoading
            .sink(receiveValue: { isLoading in
                if !isLoading {
                    self.tableView.refreshControl?.endRefreshing()
                }
            })
            .store(in: &cancellables)
        
        dataSource?.$error
            .receive(on: DispatchQueue.main)
            .sink {  error in
                if error != nil {
                    print(error!)
                    //                    self?.show(error: .refreshError, shouldDismiss: true)
                }
            }
            .store(in: &cancellables)
        
        updateListDetail()
    }
    
    @objc
    func updateListDetail() {
        dataSource?.update()
    }
    
    @objc
    func addMovie() {
        let movieId = Int.random(in: 0...600000)
        print(movieId)
        Task {
            do {
                try await dataSource?.addMovie(movieId: movieId)
                self.dataSource?.update()
            } catch {
                print(error)
            }
        }
    }
    
    @objc
    func clearList() {
        Task {
            do {
                try await dataSource?.clearList()
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = dataSource?.movie(at: indexPath.row)
        
        if let movie {
            router?.showMovieDetail(movie: movie)
        }
        
    }
    
}
