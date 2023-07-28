//
//  UserListDetailDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class UserListDetailDataSource: UITableViewDiffableDataSource<UserListDetailDataSource.Section, MovieViewModel.ID> {
    enum Section {
        case main
    }
    
    var removeMovie: ((Int) -> ())? = nil
    
    func updateDataSource(movies: [MovieViewModel], animated: Bool = true) {
        let movieIds = movies.map { $0.id }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movieIds, toSection: .main)
        apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: - Table View
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {            
            removeMovie?(indexPath.row)
        }
    }
    
}
