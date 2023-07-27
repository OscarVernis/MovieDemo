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
    
    var cancellables = Set<AnyCancellable>()
    
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
            self.showAddListAlert()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
        
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
            .sink { error in
                if error != nil {
                    print(error!)
//                    self?.show(error: .refreshError, shouldDismiss: true)
                }
            }
            .store(in: &cancellables)
        
        updateUserLists()
    }
    
    func showAddListAlert() {
        let ac = UIAlertController(title: "Create List", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Create", style: .default) { [unowned ac] _ in
               let answer = ac.textFields![0]
               if let name = answer.text {
                   self.addList(name: name)
               }
           }

           ac.addAction(submitAction)

           present(ac, animated: true)
    }
    
    func addList(name: String) {
        Task { await dataSource?.addList(name: name) }
    }
    
    @objc
    func updateUserLists() {
        dataSource?.update()
    }

    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = dataSource!.store.lists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = UserListDetailViewController(userList: list)
        vc.title = list.name
        show(vc, sender: self)
    }
    
}
