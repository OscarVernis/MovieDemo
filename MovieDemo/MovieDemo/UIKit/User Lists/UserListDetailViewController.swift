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
    
    var cancellables = Set<AnyCancellable>()
    
//    init(dataSourceProvider: @escaping (UITableView) -> UserListDetailDataSource) {
//        self.dataSourceProvider = dataSourceProvider
//        super.init(style: .plain)
//    }
        
    init(userList: UserList) {
        self.dataSourceProvider = {
            UserListDetailDataSource(tableView: $0,
                                     store: UserListDetailStore(
                                        userList: userList,
                                        service: { TMDBClient().getUserListDetails(listId: userList.id) })
            )
        }
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}
