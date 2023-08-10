//
//  ListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UICollectionViewDelegate {
    typealias DataSourceProvider = (UICollectionView) -> any PagingDataSource
    var collectionView: UICollectionView!
    
    var dataSource: (any PagingDataSource)!
    var dataSourceProvider: (UICollectionView) -> any PagingDataSource
    var layout: UICollectionViewCompositionalLayout
    
    var router: ErrorHandlingRouter?

    var didSelectedItem: ((Any) -> ())?
    
    lazy var loadingView: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .large)
    }()
    
    init(dataSourceProvider: @escaping DataSourceProvider,
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
    
    override func viewWillAppear(_ animated: Bool) {
        configureWithDefaultNavigationBarAppearance()
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
            let section = CompositionalLayoutBuilder.createListSection()
            section.contentInsets.bottom = 30
            
            return section
        }
    }
    
    static func loadingLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch sectionIndex {
            case 0:
                let section = CompositionalLayoutBuilder.createListSection()
                return section
            case 1:
                let section = CompositionalLayoutBuilder.createListSection(height: 44)
                section.contentInsets.top = 20
                section.contentInsets.bottom = 30
                return section
            default:
                return nil
            }
        }
        
        return layout
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
            self.collectionView.backgroundView = nil
            self.collectionView.refreshControl?.endRefreshing()

            if error != nil {
                self.router?.handle(error: .refreshError)
            }
        }
        
        refresh()
    }
    
    @objc func refresh() {
        if dataSource.isRefreshable, collectionView.visibleCells.count == 0 {
            collectionView.backgroundView = loadingView
            loadingView.startAnimating()
        }
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

extension ListViewController {
    convenience init<Model: Hashable, Cell: UICollectionViewCell>(models: [Model], cellConfigurator: @escaping ArrayPagingDataSource<Model, Cell>.CellConfigurator, layout: UICollectionViewCompositionalLayout = ListViewController.defaultLayout(), router: ErrorHandlingRouter? = nil) {
        let provider = { ArrayPagingDataSource(collectionView: $0, models: models, cellConfigurator: cellConfigurator) }
        self.init(dataSourceProvider: provider, layout: layout, router: router)
    }
    
    convenience init<Provider: DataProvider, Cell: UICollectionViewCell>(provider: Provider, cellConfigurator: ProviderPagingDataSource<Provider, Cell>.CellConfigurator? = nil, layout: UICollectionViewCompositionalLayout = ListViewController.loadingLayout(), router: ErrorHandlingRouter? = nil) {
        let provider = { ProviderPagingDataSource(collectionView: $0, dataProvider: provider, cellConfigurator: cellConfigurator) }
        self.init(dataSourceProvider: provider, layout: layout, router: router)
    }
}
