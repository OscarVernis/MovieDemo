//
//  ListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class ListViewController<Provider: ArrayDataProvider, Cell: UICollectionViewCell>: UIViewController, UICollectionViewDelegate {
    enum Section: Int, CaseIterable {
        case Main
    }
    
    var collectionView: UICollectionView!
    var dataSource: ListDataSource
    var provider: Provider
    
    weak var coordinator: MainCoordinator?

    var didSelectedItem: ((Int) -> ())?
    
    init(dataSource: ProviderDataSource<Provider, Cell>, coordinator: MainCoordinator? = nil) {
        self.coordinator = coordinator
        self.dataSource = ListDataSource(dataSource: dataSource)
        self.provider = dataSource.dataProvider
                
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        setup()
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func createCollectionView() {
        let layout = UICollectionViewCompositionalLayout(section: sectionLayout())
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        Cell.register(to: collectionView)
        LoadingCell.register(to: collectionView)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
        let section = sectionBuilder.createListSection()
        section.contentInsets.bottom = 30
        
        return section
    }
        
    fileprivate func setup() {
        navigationController?.delegate = self
        collectionView.backgroundColor = .asset(.AppBackgroundColor)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.keyboardDismissMode = .onDrag
                
        provider.didUpdate = { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                self.coordinator?.handle(error: .refreshError)
            }
            
            self.dataSource.loadingDataSource.isLoading = !self.provider.isLastPage
                        
            self.collectionView.refreshControl?.endRefreshing()
            self.reload()
        }
        
        provider.refresh()
    }
    
    func reload() {
        if self.collectionView.refreshControl?.isRefreshing ?? false {
            self.collectionView.refreshControl?.endRefreshing()
        }

        self.collectionView.reloadData()
    }
    
    @objc func refresh() {
        provider.refresh()
    }
    
    //MARK: - CollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 { //Loads next page when Loading Cell is showing
            provider.loadMore()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            return
        }

        didSelectedItem?(indexPath.row)
    }
    
}
