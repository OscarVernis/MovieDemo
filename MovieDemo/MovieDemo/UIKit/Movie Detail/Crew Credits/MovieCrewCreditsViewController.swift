//
//  MovieCrewCreditsViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 01/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieCrewCreditsViewController: UIViewController, UICollectionViewDelegate {
    var collectionView: UICollectionView!
    
    var dataSource: CrewCreditDataSource!
    
    var didSelectedItem: ((CrewCreditViewModel) -> ())?
    
    let model: MovieCrewCreditsViewModel
    
    init(model: MovieCrewCreditsViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        createCollectionView()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureWithDefaultNavigationBarAppearance()
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Setup
    func createCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .asset(.AppBackgroundColor)

        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    func setupDataSource() {
        dataSource = CrewCreditDataSource(collectionView: collectionView, model: model)
        dataSource.reload()
    }
    
    //MARK: - Layout
    func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = CrewCreditDataSource.Section(rawValue: sectionIndex)!
            switch section {
            case .departments:
                let sectionBuilder = MoviesCompositionalLayoutBuilder()
                let section = sectionBuilder.createHorizontalCategorySection()
                
                section.contentInsets.top = 4
                section.contentInsets.bottom = 4
                
                return section
            case .jobs:
                let sectionBuilder = MoviesCompositionalLayoutBuilder()
                
                let section = sectionBuilder.createListSection()
                section.contentInsets.bottom = 30
                
                return section
            }
        }
    }
    
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = CrewCreditDataSource.Section(rawValue: indexPath.section)
        if section == .departments {
            selectCategory(at: indexPath)
        } else if section == .jobs {
            if let model = dataSource.model(at: indexPath) {
                didSelectedItem?(model)
            }
        }
    }
    
    fileprivate func selectCategory(at newIndexPath: IndexPath) {
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
        
        dataSource.selectedDepartment = dataSource.model.departments[newIndexPath.row]
        dataSource.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let categoryCell = cell as? CategoryCell {
            categoryCell.setSelection(indexPath == dataSource.indexPathForSelectedDepartment)
        }
    }
    
}
