//
//  ListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

public class ListViewController<Provider: ArrayDataProvider> : UIViewController, UICollectionViewDelegate {
    enum Section: Int, CaseIterable {
        case Main
    }
    
    var collectionView: UICollectionView!
    
    var dataProvider: Provider!
    var dataSource: ListViewDataSource<Provider>?
    
    weak var mainCoordinator: MainCoordinator!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    fileprivate func setup() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(named: "AppBackgroundColor")
        view.addSubview(collectionView)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.register(MovieInfoCell.namedNib(), forCellWithReuseIdentifier: MovieInfoCell.reuseIdentifier)
        collectionView.register(LoadingCell.namedNib(), forCellWithReuseIdentifier: LoadingCell.reuseIdentifier)
        
        self.dataSource = ListViewDataSource(dataProvider: dataProvider, reuseIdentifier: MovieInfoCell.reuseIdentifier)
        self.collectionView.dataSource = dataSource
        self.collectionView.prefetchDataSource = dataSource
        
        dataProvider.didUpdate = refreshHandler
        dataProvider.refresh()
    }
    
    func refreshHandler() {
        if collectionView.refreshControl?.isRefreshing ?? false {
            collectionView.refreshControl?.endRefreshing()
        }
        
        collectionView.reloadData()
    }
    
    @objc func refreshMovies() {
        dataProvider.refresh()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let movie = dataProvider.models[indexPath.row]
//        mainCoordinator.showMovieDetail(movie: movie)
    }
}

//MARK: - CollectionView CompositionalLayout
extension ListViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var section: NSCollectionLayoutSection?
            let sectionBuilder = MoviesCompositionalLayoutBuilder()
            
            if sectionIndex == 0 {
                section = sectionBuilder.createInfoListSection()
            }

            return section
        }
        
        return layout
    }
    
}

