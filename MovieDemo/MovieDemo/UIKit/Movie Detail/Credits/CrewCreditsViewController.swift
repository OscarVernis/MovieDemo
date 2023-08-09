//
//  CrewCreditsViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CrewCreditsViewController: UIViewController {
    private static let globalHeaderKind = "GlobalCategorySelectionHeader"
    
    private var listViewController: ListViewController!
    private weak var dataSource: ArrayPagingDataSource<CrewCreditViewModel, CreditPhotoListCell>!
    private let viewModel: CrewCreditsViewModel
    
    private weak var selectionView: CategorySelectionView!
    private var selectedDepartment: String = ""
        
    var didSelectedItem: ((CrewCreditViewModel) -> ())?
    
    init(viewModel: CrewCreditsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = MovieString.Cast.localized
        setupListViewController()
        setupSearch()
    }
    
    private func setupListViewController() {
        let globalHeaderRegistration = UICollectionView.SupplementaryRegistration<CategorySelectionHeaderView>(elementKind: CrewCreditsViewController.globalHeaderKind) { [unowned self] header, elementKind, indexPath in
            header.selectionView.unselectedBackgroundgColor = .systemGray5
            
            header.selectionView.items = self.viewModel.departments
            header.selectionView.didSelectItem = { [unowned self] idx in
                selectedDepartment = self.viewModel.departments[idx]
                let credits = self.viewModel.jobs(in: selectedDepartment)
                self.dataSource.models = credits
                self.dataSource.reload(animated: true)
            }
            
            self.selectionView = header.selectionView
        }
        
        let provider = { [unowned self] collectionView in
            let firstDepartment = self.viewModel.departments.first!
            let credits = self.viewModel.jobs(in: firstDepartment)
            let dataSource = ArrayPagingDataSource(collectionView: collectionView, models: credits, cellConfigurator: CreditPhotoListCell.configure)
            
            dataSource.dataSource.supplementaryViewProvider = { view, kind, indexPath in
                return collectionView.dequeueConfiguredReusableSupplementary(using: globalHeaderRegistration, for: indexPath)
            }
            
            self.dataSource = dataSource
            
            return dataSource
        }
        
        listViewController = ListViewController(dataSourceProvider: provider, layout: defaultLayout(), router: nil)
        
        listViewController.didSelectedItem = { [weak self] model in
            if let crewCredit = model as? CrewCreditViewModel {
                self?.didSelectedItem?(crewCredit)
            }
        }
        
        listViewController.embed(in: self)
    }
    
    private func defaultLayout() -> UICollectionViewCompositionalLayout {
        let layout = ListViewController.defaultLayout()

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let departmentsHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: CrewCreditsViewController.globalHeaderKind, alignment: .top)

        departmentsHeader.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [departmentsHeader]
        layout.configuration = config
        
        return layout
    }

    private func setupSearch() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
    
    private func updateSearchResults(query: String) {
        guard let dataSource = listViewController.dataSource as? ArrayPagingDataSource<CrewCreditViewModel, CreditPhotoListCell>
        else { return }

        var selectedIndex: Int = 0
        viewModel.query = query
        if query.isEmpty || viewModel.departments.firstIndex(of: selectedDepartment) == nil {
            selectedDepartment = viewModel.departments.first ?? ""
        }
        
        selectedIndex = viewModel.departments.firstIndex(of: selectedDepartment) ?? 0
        
        selectionView.items = viewModel.departments
        selectionView.setSelectedCategory(index: selectedIndex, animated: true)
        dataSource.models = viewModel.jobs(in: selectedDepartment)
        dataSource.reload(animated: true)
    }
    
}

extension CrewCreditsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text ?? ""
        updateSearchResults(query: searchQuery)
    }
}
