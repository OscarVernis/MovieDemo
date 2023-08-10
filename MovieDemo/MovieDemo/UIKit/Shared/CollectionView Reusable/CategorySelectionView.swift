//
//  CategorySelectionView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class CategorySelectionView: UIView {
    private enum Section {
        case main
    }
    
    var items: [String] {
        didSet {
            reload()
        }
    }
    private var selectedIndex: Int = 0
    
    var selectedBackgroundColor: UIColor = .label
    var unselectedBackgroundgColor: UIColor = .systemGray6
    private var margin: CGFloat = 20
    
    var didSelectItem: ((Int) -> Void)? = nil
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    init(items: [String] = []) {
        self.items = items
        super.init(frame: .zero)
        setup()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setup() {
        backgroundColor = .clear
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout())
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        collectionView.anchor(to: self)
        
        CategoryCell.register(to: collectionView)
        
        dataSource =  UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            self.categoryCell(with: collectionView, indexPath: indexPath, itemIdentifier: itemIdentifier)
        })
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] _, _ in
            let sectionBuilder = CompositionalLayoutBuilder.self
            let section = sectionBuilder.createSection(itemWidth: .estimated(1),
                                                       itemHeight: .absolute(32),
                                                       groupWidth: .estimated(1),
                                                       groupHeight: .absolute(32),
                                                       margin: self.margin)
            
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 12
            
            return section
        }
        
        return layout
    }
    
    private func categoryCell(with collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        categoryCell.titleLabel.text = itemIdentifier
        categoryCell.selectedBgColor = selectedBackgroundColor
        categoryCell.unselectedBgColor = unselectedBackgroundgColor

        categoryCell.setSelection(indexPath.row == selectedIndex)
        
        return categoryCell
    }
    
    //MARK: - DataSource
    func setSelectedCategory(index: Int, animated: Bool = false) {
        guard index < items.count else { return }
        
        selectedIndex = index
        reload(animated: animated)
    }
    
    private func reload(animated: Bool = true) {        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
        updateSelectedCell(at: IndexPath(row: selectedIndex, section: 0))
    }
    
}

//MARK: - CollectionView Delegate
extension CategorySelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != selectedIndex {
            updateSelectedCell(at: indexPath)
            setSelectedCategory(index: indexPath.row)
            didSelectItem?(indexPath.row)
        }
    }
    
    fileprivate func updateSelectedCell(at newIndexPath: IndexPath) {
        //Deselect other cells
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems.filter { $0.section == newIndexPath.section }
        for indexPath in visibleIndexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
                cell.setSelection(false)
            }
        }
        
        //Select new cell
        let cell = collectionView.cellForItem(at: newIndexPath) as? CategoryCell
        cell?.setSelection(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let categoryCell = cell as? CategoryCell {
            categoryCell.setSelection(indexPath.row == selectedIndex)
        }
    }
    
}
