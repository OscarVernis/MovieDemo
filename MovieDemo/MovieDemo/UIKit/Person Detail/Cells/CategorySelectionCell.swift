//
//  CategorySelectionCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CategorySelectionCell: UICollectionViewCell {
    var selectionView: CategorySelectionView
    
    override init(frame: CGRect) {
        selectionView = CategorySelectionView()
        super.init(frame: frame)
        
        contentView.addSubview(selectionView)
        selectionView.anchor(to: contentView)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

