//
//  CrewCreditsViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CrewCreditsViewController: UIViewController {
    private let globalHeaderKind = "GlobalCategorySelectionHeader"
    
    private var listViewController: ListViewController!
    private weak var dataSource: ArrayPagingDataSource<CrewCreditViewModel, CreditPhotoListCell>!
    private let viewModel: CrewCreditsViewModel
    
    private weak var selectionView: UICategorySelectionView!
    private var selectedDepartment: String = ""
        
    var didSelectedItem: ((CrewCreditViewModel) -> ())?
    
    init(viewModel: CrewCreditsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = MovieString.Crew.localized
        setupListViewController()
        setupSearch()
    }
    
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<CategorySelectionHeaderView>
    private func setupListViewController() {
        let departmentsHeaderRegistration = HeaderRegistration(elementKind: globalHeaderKind) { [unowned self] header, elementKind, indexPath in
            header.selectionView.unselectedBackgroundgColor = .systemGray5
            
            header.selectionView.items = viewModel.departments
            header.selectionView.didSelectItem = { [unowned self] idx in
                selectedDepartment = viewModel.departments[idx]
                updateSelectedDepartment()
            }
            
            self.selectionView = header.selectionView
        }
        
        let dataSourceProvider = { [unowned self] collectionView in
            let firstDepartment = viewModel.departments.first ?? ""
            let credits = viewModel.jobs(in: firstDepartment)
            let dataSource = ArrayPagingDataSource(collectionView: collectionView, models: credits, cellConfigurator: CreditPhotoListCell.configure, supplementaryViewProvider: { collectionView, elementKind, indexPath in
                return collectionView.dequeueConfiguredReusableSupplementary(using: departmentsHeaderRegistration, for: indexPath)
            })
            
            self.dataSource = dataSource
            
            return dataSource
        }
        
        listViewController = ListViewController(dataSourceProvider: dataSourceProvider, layout: createLayout())
        
        listViewController.didSelectedItem = { [weak self] model in
            if let crewCredit = model as? CrewCreditViewModel {
                self?.didSelectedItem?(crewCredit)
            }
        }
        
        listViewController.embed(in: self)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = ListViewController.defaultLayout()
        
        if !viewModel.departments.isEmpty {
            layout.configuration = CompositionalLayoutBuilder.createGlobalHeaderConfiguration(height: .absolute(40), kind: globalHeaderKind)
        }
        
        return layout
    }

    private func setupSearch() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
    
    private func updateSelectedDepartment() {
        let credits = viewModel.jobs(in: selectedDepartment)
        self.dataSource.models = credits
        self.dataSource.reload(animated: true)
    }
    
    private func updateSearchResults(query: String) {
        //Query will filter credits and departments that include those credits
        viewModel.query = query
        
        //Update selected deparment index in case filter departments are different than previous query
        var selectedIndex: Int
        if let index = viewModel.departments.firstIndex(of: selectedDepartment) {
            selectedIndex = index
        } else { //If filtered credits don't included credits with current selected deparment, change to first available deparment
            selectedDepartment = viewModel.departments.first ?? ""
            selectedIndex = 0
        }
        
        //Update selectionView with new departments
        selectionView.items = viewModel.departments
        selectionView.setSelectedCategory(index: selectedIndex, animated: true)
        updateSelectedDepartment()
    }
    
}

extension CrewCreditsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text ?? ""
        updateSearchResults(query: searchQuery)
    }
}
