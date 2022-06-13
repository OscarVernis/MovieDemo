//
//  ListDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 12/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

class ListDataSource: SectionedCollectionDataSource {
    var loadingDataSource = LoadingDataSource()
    
    init(dataSource: UICollectionViewDataSource) {
        super.init(dataSources: [dataSource,
                                 loadingDataSource
                                ])
    }
}
