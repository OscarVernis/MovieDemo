//
//  GenericCollectionDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class GenericCollectionDataSource: NSObject, UICollectionViewDataSource {
    var sections: [ConfigurableSection]
    
    unowned var collectionView: UICollectionView! {
        didSet {
            setup()

        }
    }
    
    var didUpdate: ((Int) -> Void)?
    
    required public init(sections: [ConfigurableSection]) {
        self.sections = sections
        super.init()
    }
    
    fileprivate func setup() {
        for (index, section) in sections.enumerated() {
            section.registerReusableViews(withCollectionView: collectionView)
            
            if var section = section as? FectchableSection {
                section.didUpdate = {
                    self.didUpdate(sectionIndex: index)
                }
            }
        }
        
    }
    
    fileprivate func didUpdate(sectionIndex: Int) {
        didUpdate?(sectionIndex)
        collectionView.reloadData()
    }
    
    func refresh() {
        sections.forEach { section in
            if let section = section as? FectchableSection {
                section.refresh()
            }
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
