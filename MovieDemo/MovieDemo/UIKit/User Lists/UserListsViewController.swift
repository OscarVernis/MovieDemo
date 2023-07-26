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
    enum Section {
        case main
    }
    
    var lists: [UserList] = []
    let service: UserListsService?
    var cancellable: AnyCancellable?
    var dataSource: UITableViewDiffableDataSource<Section, UserList>?

    
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
        
        dataSource = UITableViewDiffableDataSource<Section, UserList>(tableView: tableView, cellProvider: { (tableView, indexPath, userList) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = userList.name
            cell.detailTextLabel?.text = userList.description
            
            return cell
        })
        
        updateUserLists()
    }
    
    private func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(lists, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    @objc
    func updateUserLists() {
        guard let service else { return }
        
        cancellable = service(1)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { result in
                self.lists = result.lists
                self.updateDatasource()
                self.tableView.refreshControl?.endRefreshing()
                print("Done")
            })
    }

}
