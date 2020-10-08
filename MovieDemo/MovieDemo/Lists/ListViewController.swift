//
//  ListViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

public class ListViewController: UIViewController, GenericCollection {
    enum Section: Int, CaseIterable {
        case Main
    }
    
    var collectionView: UICollectionView!
    var dataSource: GenericCollectionDataSource!

    var didSelectedItem: ((Int) -> ())?
       
    var mainSection: FetchableSection
    var loadingSection = LoadingSection()
    
    init(section: FetchableSection) {
        self.mainSection = section
                
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
        
    fileprivate func setup() {
        navigationController?.delegate = self
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.keyboardDismissMode = .onDrag
        
        dataSource = GenericCollectionDataSource(collectionView: collectionView, sections: [mainSection, loadingSection])
        
        mainSection.didUpdate = { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                AlertManager.showRefreshErrorAlert(sender: self)
            }
            
            self.loadingSection.isLoading = !self.mainSection.isLastPage
            
            self.collectionView.refreshControl?.endRefreshing()
            self.reload()
        }
        
        mainSection.refresh()
    }
    
    func reload() {
        if self.collectionView.refreshControl?.isRefreshing ?? false {
            self.collectionView.refreshControl?.endRefreshing()
        }

        self.collectionView.reloadData()
    }
    
    @objc func refresh() {
        mainSection.refresh()
    }
    
}

    //MARK: - CollectionView Delegate
extension ListViewController:UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 { //Loads next page when Loading Cell is showing
            mainSection.fetchNextPage()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            return
        }

        didSelectedItem?(indexPath.row)
    }
    
}
