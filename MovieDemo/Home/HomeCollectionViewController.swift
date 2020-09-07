//
//  HomeViewControllerCollectionViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let homeCollectionViewDataSource = HomeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = homeCollectionViewDataSource
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth = UIScreen.main.bounds.size.width
        return CGSize(width: cellWidth, height: 300)
    }
}
