//
//  CrewCreditDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CrewCreditDataSource {
    enum Section: Int, CaseIterable {
        case departments
        case jobs
    }
        
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    var model: MovieCrewCreditsViewModel
    var selectedDepartment: String = ""
    var indexPathForSelectedDepartment: IndexPath? {
        guard let row = model.departments.firstIndex(of: selectedDepartment) else { return nil }
        return IndexPath(row: row, section: 0)
    }
    
    var didUpdateSelectedCategory: ((IndexPath) -> Void)? = nil
    
    init(collectionView: UICollectionView, model: MovieCrewCreditsViewModel) {
        self.model = model

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
        let title = model.departments[indexPath.row]
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        categoryCell.titleLabel.text = title
        categoryCell.unselectedBgColor = .systemGray5
        
        return categoryCell
    }
    
    private func jobCell(with collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource.itemIdentifier(for: indexPath) as! CrewCreditViewModel
        return collectionView.cell(at: indexPath, model: model, cellConfigurator: CreditPhotoListCell.configure)
    }
    
    private func registerReusableViews(with collectionView: UICollectionView) {
        CategoryCell.register(to: collectionView)
        CreditPhotoListCell.register(to: collectionView)
    }
    
    //MARK: - Data Source
    func reload(animated: Bool = true) {
        var updateSelected = false
        if model.departments.firstIndex(of: selectedDepartment) == nil {
            selectedDepartment = model.departments.first ?? ""
            updateSelected = true
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        if !model.departments.isEmpty {
            snapshot.appendSections([.departments])
            snapshot.appendItems(model.departments, toSection: .departments)
        }
        if let selectedJobs = model.departmentJobs[selectedDepartment], !selectedJobs.isEmpty {
            snapshot.appendSections([.jobs])
            snapshot.appendItems(selectedJobs, toSection: .jobs)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animated)
        
        if updateSelected, let indexPath = indexPathForSelectedDepartment {
            didUpdateSelectedCategory?(indexPath)
        }

    }
        
    func category(at indexPath: IndexPath) -> String? {
        dataSource.itemIdentifier(for: indexPath) as? String
    }
    func model(at indexPath: IndexPath) -> CrewCreditViewModel? {
        dataSource.itemIdentifier(for: indexPath) as? CrewCreditViewModel
    }
    
}


