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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.update()
    }
    
    func setup() {
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(update), for: .valueChanged)
        
        let action = UIAction { [unowned self] _ in
            self.showAddListAlert()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    func setupDataSource() {
        UserListCell.register(to: tableView)
        tableView.rowHeight = 111
        tableView.separatorStyle = .none
        
        dataSource = UserListsDataSource(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.reuseIdentifier, for: indexPath) as! UserListCell
            
            let userList = self.store.lists[indexPath.row]
            cell.titleLabel.text = userList.name
            cell.descriptionLabel.text = userList.description
            cell.descriptionLabel.isHidden = userList.description.isEmpty
            cell.countLabel.text = "\(userList.itemCount) ITEMS"
            
            cell.selectionStyle = .none

            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
        
        dataSource.removeList = { [weak self] idx in
            self?.removeList(at: idx)
        }
    }
                                         
    fileprivate func setupStore() {
        store.$lists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lists in
                self?.updateDataSource(lists: lists)
            }
            .store(in: &cancellables)
        
        store.$isLoading
            .sink(receiveValue: { [tableView] isLoading in
                if !isLoading {
                    tableView?.refreshControl?.endRefreshing()
                }
            })
            .store(in: &cancellables)
        
        store.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [router] error in
                router?.handle(error: .refreshError)
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource(lists: [UserList]) {
        let animated = dataSource?.snapshot().numberOfItems != 0
        
        dataSource?.updateDataSource(lists: lists, animated: animated, forceReload: store.shouldReload)
    }
    
    //MARK: - Actions
    @objc
    func update() {
        store.update()
    }
    
    func showAddListAlert() {
        let ac = UIAlertController(title: "Create List", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Create", style: .default) { _ in
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
        
        router?.showUserListDetail(list: list)
    }
    
}
