//
//  ListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

public class ListViewController<Provider: ArrayDataProvider, Configurator: CellConfigurator> : UIViewController, UICollectionViewDelegate {
    enum Section: Int, CaseIterable {
        case Main
    }
    
    var collectionView: UICollectionView!
    
    var dataProvider: Provider!
    var dataSource: ListViewDataSource<Provider, Configurator>?
    
    var didSelectedItem: ((Int, Provider.Model) -> ())?
       
    weak var mainCoordinator: MainCoordinator!
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
        
    fileprivate func setup() {
        navigationController?.delegate = self
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .appBackgroundColor
        view.addSubview(collectionView)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.register(CreditPhotoListCell.namedNib(), forCellWithReuseIdentifier: CreditPhotoListCell.reuseIdentifier)
        collectionView.register(MovieInfoListCell.namedNib(), forCellWithReuseIdentifier: MovieInfoListCell.reuseIdentifier)
        collectionView.register(LoadingCell.namedNib(), forCellWithReuseIdentifier: LoadingCell.reuseIdentifier)
        
        dataSource?.showLoadingIndicator = true
        collectionView.dataSource = dataSource
        dataSource?.dataProvider = dataProvider
        
        dataProvider.didUpdate = { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                AlertManager.showRefreshErrorAlert(sender: self)
            }
            
            self.dataSource?.showLoadingIndicator = false
            self.collectionView.refreshControl?.endRefreshing()
            self.reload()
        }
        
        dataProvider.refresh()
    }
    
    func reload() {
        if self.collectionView.refreshControl?.isRefreshing ?? false {
            self.collectionView.refreshControl?.endRefreshing()
        }

        self.collectionView.reloadData()
    }
    
    @objc func refresh() {
        dataProvider.refresh()
    }
    
    
    //MARK: - CollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= dataProvider.models.count { //Loads next page when Loading Cell is showing
            dataProvider.fetchNextPage()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= dataProvider.models.count {
            return
        }
        
        let model = dataProvider.models[indexPath.row]
        
        didSelectedItem?(indexPath.row, model)
    }
}

//MARK: - CollectionView CompositionalLayout
extension ListViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            var section: NSCollectionLayoutSection?
            let sectionBuilder = MoviesCompositionalLayoutBuilder()
            
            if sectionIndex == 0 {
                let columns = self.view.frame.width > 500 ? 2 : 1
                
                section = sectionBuilder.createListSection(columns: columns)
                section?.contentInsets.bottom = 30
            }

            return section
        }
        
        return layout
    }
    
}

