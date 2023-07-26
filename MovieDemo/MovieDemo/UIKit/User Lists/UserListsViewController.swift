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
    let service: UserListsService?
    var dataSource: UserListsDataSource?

    
    init(service: UserListsService?) {
        self.service = service
        
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateUserLists), for: .valueChanged)
        
        dataSource = UserListsDataSource(service: service, tableView: tableView)
        
        updateUserLists()
    }
    
    @objc
    func updateUserLists() {
        dataSource?.update()
    }

}
