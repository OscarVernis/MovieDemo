//
//  CrewCreditDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CrewCreditDataSource {
    typealias Model = CrewCreditViewModel
    
    enum Section: Int, CaseIterable {
        case departments
        case jobs
    }
        
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    var model: MovieCrewCreditsViewModel
    var selectedDepartment: String
    var indexPathForSelectedDepartment: IndexPath {
        let row = model.departments.firstIndex(of: selectedDepartment)!
        return IndexPath(row: row, section: 0)
    }
    
    init(collectionView: UICollectionView, model: MovieCrewCreditsViewModel) {
        self.model = model
        self.selectedDepartment = model.departments.first ?? ""
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            let section = CrewCreditDataSource.Section(rawValue: indexPath.section)!
            switch section {
            case .departments:
                return self.categoryCell(with: collectionView, indexPath: indexPath)
            case .jobs:
                return jobCell(with: collectionView, indexPath: indexPath)
            }
        })
        
        registerReusableViews(with: collectionView)
    }
    
    //MARK: - Cell Setup
    private func categoryCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let title = self.model.departments[indexPath.row]
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        categoryCell.titleLabel.text = title
        categoryCell.unselectedBgColor = .systemGray5
        
        return categoryCell
    }
    
    private func jobCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.model.departmentJobs[self.selectedDepartment]![indexPath.row]
        return collectionView.cell(at: indexPath, model: model, cellConfigurator: CreditPhotoListCell.configure)
    }
    
    private func registerReusableViews(with collectionView: UICollectionView) {
        CategoryCell.register(to: collectionView)
        CreditPhotoListCell.register(to: collectionView)
    }
    
    //MARK: - Data Source
    func reload(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<CrewCreditDataSource.Section, AnyHashable>()
        snapshot.appendSections([Section.departments, Section.jobs])
        snapshot.appendItems(model.departments, toSection: Section.departments)
        snapshot.appendItems(model.departmentJobs[selectedDepartment]!, toSection: Section.jobs)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
        
    func model(at indexPath: IndexPath) -> Model? {
        dataSource.itemIdentifier(for: indexPath) as? Model
    }
    
}


