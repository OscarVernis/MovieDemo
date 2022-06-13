//
//  SearchDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 13/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class SearchDataSource: ProviderDataSource<SearchDataProvider, UICollectionViewCell> {
    init() {
        super.init(dataProvider: SearchDataProvider(), reuseIdentifier: "")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataProvider.itemCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataProvider.item(atIndex: indexPath.row)
        let cell: UICollectionViewCell
        
        switch item {
        case let movie as MovieViewModel:
            let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoListCell.reuseIdentifier, for: indexPath) as! MovieInfoListCell
            MovieInfoCellConfigurator().configure(cell: movieCell, with: movie)
            cell = movieCell
        case let person as PersonViewModel:
            let personCell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditPhotoListCell.reuseIdentifier, for: indexPath) as! CreditPhotoListCell
            PersonCreditPhotoListConfigurator().configure(cell: personCell, person: person)
            cell = personCell
        default:
            fatalError("Unknown Media Type")
        }
        
        return cell
    }
    
}
