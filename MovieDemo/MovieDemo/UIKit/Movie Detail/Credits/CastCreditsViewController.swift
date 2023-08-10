//
//  CastCreditsViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CastCreditsViewController: UIViewController {
    var listViewController: ListViewController!
    let credits: [CastCreditViewModel]
        
    var didSelectedItem: ((CastCreditViewModel) -> ())?
    
    var dataSource: ArrayPagingDataSource<CastCreditViewModel, CreditPhotoListCell> {
        listViewController.dataSource as! ArrayPagingDataSource<CastCreditViewModel, CreditPhotoListCell>
    }
    
    init(credits: [CastCreditViewModel]) {
        self.credits = credits
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
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
        listViewController = ListViewController(models: credits, cellConfigurator: CreditPhotoListCell.configure)
        
        listViewController.didSelectedItem = { [weak self] model in
            if let castCredit = model as? CastCreditViewModel {
                self?.didSelectedItem?(castCredit)
            }
        }
        
        listViewController.embed(in: self)
    }
    
    private func setupSearch() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
    
    private func updateSearchResults(query: String) {
        if query.isEmpty {
            dataSource.models = credits
            dataSource.reload(animated: false)
            return
        }
        
        let filteredCredits = credits.filter {
            $0.name.lowercased().contains(query.lowercased()) ||
            $0.character.lowercased().contains(query.lowercased())
        }
        dataSource.models = filteredCredits
        dataSource.reload(animated: true)
    }
    
}

extension CastCreditsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text ?? ""
        updateSearchResults(query: searchQuery)
    }
}
