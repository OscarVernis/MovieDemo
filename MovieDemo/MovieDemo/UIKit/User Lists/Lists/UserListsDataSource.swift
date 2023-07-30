//
//  UserListsDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class UserListsDataSource: UITableViewDiffableDataSource<UserListsDataSource.Section, UserList.ID> {
    enum Section {
        case main
    }
    
    var removeList: ((Int) -> ())? = nil
    
    func updateDataSource(lists: [UserList], animated: Bool = true, forceReload: Bool = false) {
        let listIds = lists.map { $0.id }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserList.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(listIds, toSection: .main)
        
        if forceReload {
            snapshot.reloadItems(listIds)
        }
        
        apply(snapshot, animatingDifferences: animated)
    }
        
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeList?(indexPath.row)
        }
    }
    
}
