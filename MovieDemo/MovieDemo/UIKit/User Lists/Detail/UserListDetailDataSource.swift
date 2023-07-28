//
//  UserListDetailDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import Combine

class UserListDetailDataSource: UITableViewDiffableDataSource<UserListDetailDataSource.Section, MovieViewModel> {
    enum Section {
        case main
    }
    
    var removeMovie: ((Int) -> ())? = nil
    
    func updateDataSource(movies: [MovieViewModel], animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        apply(snapshot, animatingDifferences: false)
    }
    
    func remove(movie: MovieViewModel) {
        var snapshot = snapshot()
        snapshot.deleteItems([movie])
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
