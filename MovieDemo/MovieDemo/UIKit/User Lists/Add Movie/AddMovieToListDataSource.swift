//
//  AddMovieToListDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class AddMovieToListDataSource: UITableViewDiffableDataSource<AddMovieToListDataSource.Section, MovieViewModel.ID> {
    enum Section {
        case main
    }
    
    var showSectionHeader = true

    func update(movies: [MovieViewModel], animated: Bool = true) {
        let movieIds = movies.map { $0.id }

        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieViewModel.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movieIds, toSection: .main)
        apply(snapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        showSectionHeader ? "RECENT" : nil
    }
    
}
