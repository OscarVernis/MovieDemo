//
//  GenericCollectionViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class GenericListCollectionViewController: UIViewController, GenericCollection {    
    var collectionView: UICollectionView!
    var dataSource: GenericCollectionDataSource
    
    weak var mainCoordinator: MainCoordinator!
    
    var didSelectItem: ((Movie) -> ())?
    
    var mainSection: ConfigurableSection!
    var loadingSection: LoadingSection = LoadingSection()


    //MARK:- Setup
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(title: String, section: ConfigurableSection) {
        self.mainSection = section
        
        var sections: [ConfigurableSection] = [mainSection]
        if let _ = mainSection as? FectchableSection {
            sections.append(loadingSection)
        }
        
        self.dataSource = GenericCollectionDataSource(sections: sections)
        super.init(nibName: nil, bundle: nil)
                        
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        setup()
        dataSource.refresh()
    }
    
    fileprivate func setup() {
        collectionView.backgroundColor = .appBackgroundColor
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.keyboardDismissMode = .onDrag
        
        dataSource.collectionView = collectionView
        dataSource.didUpdate = { sectionIndex in
            if sectionIndex == 0, let section = self.mainSection as? FectchableSection {
                self.loadingSection.isLoading = !section.isLastPage
            }
        }
        
        refresh()
    }
    
    //MARK:- Actions
    func reload() {
        if self.collectionView.refreshControl?.isRefreshing ?? false {
            self.collectionView.refreshControl?.endRefreshing()
        }

        self.collectionView.reloadData()
    }
    
    @objc func refresh() {
        dataSource.refresh()
    }
    
    //MARK: - CollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1, let section = mainSection as? FectchableSection { //Loads next page when Loading Cell is showing
            section.fetchNextPage()
        }
        
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0, let section = mainSection as? MovieListSection {
            let movie = section.dataProvider.movies[indexPath.row]
            didSelectItem?(movie)
        }
    }
    
}
