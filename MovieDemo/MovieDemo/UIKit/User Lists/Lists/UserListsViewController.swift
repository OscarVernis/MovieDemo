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
    let store: UserListsStore
    var router: UserListsRouter?
    
    var dataSource: UserListsDataSource!
    
    var cancellables = Set<AnyCancellable>()

    init(store: UserListsStore, router: UserListsRouter? = nil) {
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

        setup()
        setupDataSource()
        setupStore()
        update()
    }
    
    func setup() {
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(update), for: .valueChanged)
        
        let action = UIAction { _ in
            self.showAddListAlert()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    func setupDataSource() {
        UserListCell.register(to: tableView)
        tableView.rowHeight = 111
        tableView.separatorStyle = .none
        
        dataSource = UserListsDataSource(tableView: tableView, cellProvider: { tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.reuseIdentifier, for: indexPath) as! UserListCell
            
            let userList = self.store.lists[indexPath.row]
            cell.titleLabel.text = userList.name
            cell.descriptionLabel.text = userList.description
            cell.descriptionLabel.isHidden = userList.description.isEmpty
            cell.countLabel.text = "\(userList.itemCount) ITEMS"
            
            cell.selectionStyle = .none

            return cell
        })
        
        dataSource.removeList = { [weak self] idx in
            self?.removeList(at: idx)
        }
    }
                                         
    fileprivate func setupStore() {
        store.$lists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lists in
                let animated = self?.dataSource.snapshot().numberOfItems != 0
                self?.dataSource.updateDataSource(lists: lists, animated: animated)
            }
            .store(in: &cancellables)
        
        store.$isLoading
            .sink(receiveValue: { [weak self] isLoading in
                if !isLoading {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            })
            .store(in: &cancellables)
        
        store.$error
            .receive(on: DispatchQueue.main)
            .sink { error in
                if error != nil {
                    print(error!)
//                    self?.show(error: .refreshError, shouldDismiss: true)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Actions
    @objc
    func update() {
        store.update()
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
        Task { await store.addList(name: name, description: "") }
    }
    
    func removeList(at idx: Int) {
        Task { await store.removeList(at: idx) }
    }

    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = store.lists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        router?.showUserListDetail(list: list)
    }
    
}
