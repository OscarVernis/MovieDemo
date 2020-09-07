//
//  HomeDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

enum HomeSection: CaseIterable {
    case NowPlaying
    case Popular
    case TopRated
    case Upcoming
}

class HomeDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeSectionCell
        
        let section = HomeSection.allCases[indexPath.section]
        switch section {
        case .NowPlaying:
            cell.title.text = "Now Playing"
            cell.collectionView.register(UINib(nibName: "MovieBannerCell", bundle: .main), forCellWithReuseIdentifier: "BannerCell")
            
            Movie.fetchNowPlaying { (movies, totalPages, error) in
                let dataSource = CollectionViewDataSource(models: movies, configurator: MovieBannerCellConfigurator(), reuseIdentifier: "BannerCell")
                cell.collectionView.dataSource = dataSource
            }
            
        case .Popular:
            cell.title.text = "Popular"
        case .TopRated:
            cell.title.text = "Top Rated"
        case .Upcoming:
            cell.title.text = "Upcoming"
        }
        
        return cell
    }
}
