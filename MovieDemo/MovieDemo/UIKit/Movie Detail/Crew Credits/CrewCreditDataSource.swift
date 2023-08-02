//
//  CrewCreditDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CrewCreditDataSource: UICollectionViewDiffableDataSource<CrewCreditDataSource.Section, AnyHashable> {
    typealias Model = CrewCreditViewModel
    
    enum Section: Int, CaseIterable {
        case departments
        case jobs
    }
        
    var model: MovieCrewCreditsViewModel
    var selectedDepartment: String
    var indexPathForSelectedDepartment: IndexPath {
        let row = model.departments.firstIndex(of: selectedDepartment)!
        return IndexPath(row: row, section: 0)
    }
    
    init(collectionView: UICollectionView, model: MovieCrewCreditsViewModel, cellProvider: @escaping UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>.CellProvider) {
        self.model = model
        
        self.selectedDepartment = model.departments.first ?? ""
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }
    
    func reload(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<CrewCreditDataSource.Section, AnyHashable>()
        snapshot.appendSections([Section.departments, Section.jobs])
        snapshot.appendItems(model.departments, toSection: Section.departments)
        snapshot.appendItems(model.departmentJobs[selectedDepartment]!, toSection: Section.jobs)
        apply(snapshot, animatingDifferences: animated)
    }
        
    func model(at indexPath: IndexPath) -> Model? {
        return itemIdentifier(for: indexPath) as? Model
    }
    
}


