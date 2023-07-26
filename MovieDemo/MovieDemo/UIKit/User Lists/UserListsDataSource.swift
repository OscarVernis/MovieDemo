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
            .sink { lists in
                self.updateDataSource(lists: lists)
            }
            .store(in: &cancellables)
        
        store.$isLoading
            .assign(to: &$isLoading)
    }
    
    fileprivate func updateDataSource(lists: [UserList]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(lists, toSection: .main)
        apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: - Actions
    func update() {
        store.update()
    }
    
    func addList(name: String, description: String? = nil) {
        Task {
            try await store.addList(name: name, description: description ?? "")
        }
    }
    
    func delete(list: UserList) {
        Task {
            try await store.delete(list: list)
        }
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
