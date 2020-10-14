//
//  GenericCollectionDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class GenericCollectionDataSource: NSObject, UICollectionViewDataSource {
    var sections: [ConfigurableSection] {
        didSet {
            setup()
            refresh()
        }
    }
    
    unowned var collectionView: UICollectionView!
    
    var didUpdate: ((Int) -> Void)?
    
    required public init(collectionView: UICollectionView, sections: [ConfigurableSection]) {
        self.collectionView = collectionView
        self.sections = sections
        super.init()
        
        setup()
    }
    
    fileprivate func setup() {
        collectionView.dataSource = self
        
        for (index, section) in sections.enumerated() {
            section.registerReusableViews(withCollectionView: collectionView)
            
            if var section = section as? FetchableSection {
                section.didUpdate = { error in
                    if error == nil {
                        self.didUpdate(sectionIndex: index)
                    }
                }
            }
        }
        
    }
    
    fileprivate func didUpdate(sectionIndex: Int) {
        didUpdate?(sectionIndex)
        collectionView.reloadData()
    }
    
    func refresh() {
        for section in sections where section is FetchableSection {
            (section as! FetchableSection).refresh()
        }
        
    }
    
    //MARK:- UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].itemCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        
        return section.cell(withCollectionView: collectionView, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]

        return section.reusableView(withCollectionView: collectionView, kind: kind, indexPath: indexPath)
    }
    
}
