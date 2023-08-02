//
//  ListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDelegate {
    var collectionView: UICollectionView!
    
    var dataSource: (any PagingDataSource)!
    var dataSourceProvider: (UICollectionView) -> any PagingDataSource
    var layout: UICollectionViewCompositionalLayout
    
    var router: ErrorHandlingRouter?

    var didSelectedItem: ((Any) -> ())?
    
    init(dataSourceProvider: @escaping (UICollectionView) -> any PagingDataSource,
         layout: UICollectionViewCompositionalLayout = ListViewController.defaultLayout(),
         router: ErrorHandlingRouter? = nil) {
        self.dataSourceProvider = dataSourceProvider
        self.layout = layout
        self.router = router
                
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        dataSource = dataSourceProvider(collectionView)
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    
    static func defaultLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let sectionBuilder = MoviesCompositionalLayoutBuilder()
            
            let section = sectionBuilder.createListSection()
            section.contentInsets.bottom = 30
            
            return section
        }
    }
        
    fileprivate func setup() {
        collectionView.backgroundColor = .asset(.AppBackgroundColor)
        
        if dataSource.isRefreshable {
            collectionView.refreshControl = UIRefreshControl()
            collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        }
        
        collectionView.keyboardDismissMode = .onDrag
                
        dataSource.didUpdate = { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                self.router?.handle(error: .refreshError)
            }
                                    
            self.collectionView.refreshControl?.endRefreshing()
        }
        
        refresh()
    }
    
    @objc func refresh() {
        dataSource.refresh()
    }
    
    //MARK: - CollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 { //Loads next page when Loading Cell is showing
            dataSource.loadMore()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = dataSource.model(at: indexPath) {
            didSelectedItem?(model)
        }
    }
    
}
