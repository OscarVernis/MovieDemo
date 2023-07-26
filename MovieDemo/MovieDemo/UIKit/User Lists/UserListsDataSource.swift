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
    
    var lists: [UserList] = []
    let service: UserListsService?
    var cancellable: AnyCancellable?
    
    init(service: UserListsService?, tableView: UITableView) {
        self.service = service
        super.init(tableView: tableView) { tableView, indexPath, userList in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = userList.name
            cell.detailTextLabel?.text = userList.description
            
            return cell
        }
    }
    
    func update() {
        guard let service else { return }
        
        cancellable = service(1)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { result in
                self.lists = result.lists
                self.updateDataSource()
                print("Done")
            })
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(lists, toSection: .main)
        apply(snapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lists.remove(at: indexPath.row)
            updateDataSource()
        }
    }
}
