//
//  UserListsViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class UserListsViewController: UITableViewController {
    var dataSource: UserListsDataSource?
    var dataSourceProvider: (UITableView) -> UserListsDataSource
    
    init(dataSourceProvider: @escaping (UITableView) -> UserListsDataSource) {
        self.dataSourceProvider = dataSourceProvider
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
        refreshControl?.addTarget(self, action: #selector(updateUserLists), for: .valueChanged)
        
        let action = UIAction { _ in
            self.dataSource?.addList()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
        
        dataSource = dataSourceProvider(tableView)
        
        updateUserLists()
    }
    
    @objc
    func updateUserLists() {
        dataSource?.update()
    }

}
