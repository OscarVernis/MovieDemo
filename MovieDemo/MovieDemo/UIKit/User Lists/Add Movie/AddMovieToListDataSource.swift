//
//  AddMovieToListDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class AddMovieToListDataSource: UITableViewDiffableDataSource<AddMovieToListDataSource.Section, MovieViewModel> {
    enum Section {
        case main
    }

    func update(movies: [MovieViewModel], reload: MovieViewModel? = nil, animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        
        if let reload {
            snapshot.reloadItems([reload])
        }
        
        apply(snapshot, animatingDifferences: animated)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "RECENT"
    }
    
}
