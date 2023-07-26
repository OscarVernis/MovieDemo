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
    
    fileprivate func setupStore() {
        store.$lists
            .sink { lists in
                self.updateDataSource(lists: lists)
            }
            .store(in: &cancellables)
        
    }
    
    fileprivate func updateDataSource(lists: [UserList]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(lists, toSection: .main)
        apply(snapshot, animatingDifferences: true)
    }
    
    func update() {
        store.update()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            lists.remove(at: indexPath.row)
//            updateDataSource()
        }
    }
    
}
