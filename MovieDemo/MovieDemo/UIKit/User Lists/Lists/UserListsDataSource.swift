//
//  UserListsDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class UserListsDataSource: UITableViewDiffableDataSource<UserListsDataSource.Section, UserList> {
    enum Section {
        case main
    }
    
    @Published private(set) var isLoading = false
    @Published var error: Error? = nil

    let store: UserListsStore
    var cancellables: Set<AnyCancellable> = []
    
    init(store: UserListsStore, tableView: UITableView) {
        self.store = store
        super.init(tableView: tableView) { tableView, indexPath, userList in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = userList.name
            cell.detailTextLabel?.text = userList.description
            
            return cell
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setupStore()
        update()
    }
    
    //MARK: - Setup
    fileprivate func setupStore() {
        store.$lists
            .receive(on: DispatchQueue.main)
            .sink { lists in
                let animated = self.snapshot().numberOfItems != 0
                self.updateDataSource(lists: lists, animated: animated)
            }
            .store(in: &cancellables)
        
        store.$isLoading
            .assign(to: &$isLoading)
        
        store.$error
            .onCompletion { self.error = nil }
            .assign(to: &$error)
    }
    
    fileprivate func updateDataSource(lists: [UserList], animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(lists, toSection: .main)
        apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: - Actions
    func update() {
        store.update()
    }
    
    func addList(name: String, description: String? = nil) async {
        await store.addList(name: name, description: description ?? "")
    }
    
    func delete(list: UserList) {
        Task { await store.delete(list: list) }
    }
    
    //MARK: - Table View
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = store.lists[indexPath.row]
            delete(list: list)
        }
    }
    
}
