//
//  PersonDetailDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonDetailDataSource {
    enum Section: Hashable {
        case loading
        case overview
        case popular
        case departments
        case credits(department: String)
        case info
        
        var sectionTitle: String {
            switch self {
            case .overview, .info, .loading:
                return ""
            case .popular:
                return .localized(PersonString.KnownFor)
            case .departments:
                return .localized(PersonString.Credits)
            case .credits(department: let department):
                return department
            }
        }
    }
    
    var person: PersonViewModel!
    var isLoading = false
    let loadingItemId = UUID().uuidString
    
    var overviewSectionID = UUID().uuidString
    var isOverviewExpanded: Bool = false
    var overviewExpandAction: (() -> ())?
    
    var socialItemId = UUID().uuidString
    var openSocialLink: ((SocialLink) -> ())?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    var sections: [Section] = []
    
    var departmentsSectionID = UUID().uuidString
    var creditSections: [Section] = []
    var selectedCreditSection: Section!
    
    var willChangeSelectedDepartment: ((String) -> Void)? = nil
    
    init(collectionView: UICollectionView) {

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            
            cell(for: collectionView, with: indexPath, identifier: itemIdentifier)
        })
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, elementKind, indexPath in
            self.sectionTitleView(collectionView: collectionView, at: indexPath)
        }
        registerReusableViews(collectionView: collectionView)
    }
    
    //MARK: - Cell Setup
    func registerReusableViews(collectionView: UICollectionView) {
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        OverviewCell.register(to: collectionView)
        PersonCreditCell.register(to: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
        CategorySelectionCell.registerClass(to: collectionView)
        InfoListCell.register(to: collectionView)
        SocialCell.register(to: collectionView)
        LoadingCell.register(to: collectionView)
    }
    
    func sectionTitleView(collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        
        let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView
        
        let title = section.sectionTitle
        SectionTitleView.configureForDetail(headerView: sectionTitleView, title: title)
        
        return sectionTitleView
    }
    
    private func cell(for collectionView: UICollectionView, with indexPath: IndexPath, identifier: AnyHashable) -> UICollectionViewCell {
        let section = sections[indexPath.section]
    
        switch section {
        case .loading:
            return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
        case .overview:
            return overviewCell(at: indexPath, with: collectionView, identifier: identifier)
        case .popular:
            let movie = identifier as! MovieViewModel
            return collectionView.cell(at: indexPath, model: movie, cellConfigurator: MoviePosterInfoCell.configureWithRating)
        case .departments:
            return categoryCell(at: indexPath, with: collectionView, identifier: identifier)
        case .credits:
            let crewCredit = identifier as! PersonCreditViewModel
            return collectionView.cell(at: indexPath, model: crewCredit, cellConfigurator: PersonCreditCell.configure)
        case .info:
            return infoCell(at: indexPath, with: collectionView, identifier: identifier)
        }
    }
    
    private func overviewCell(at indexPath: IndexPath, with collectionView: UICollectionView, identifier: AnyHashable) -> UICollectionViewCell {
        let overviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.reuseIdentifier, for: indexPath) as! OverviewCell
        overviewCell.textLabel.text = person.biography
        overviewCell.isExpanded = isOverviewExpanded
        overviewCell.expandButton.addTarget(self, action: #selector(expandOverview), for: .touchUpInside)
        return overviewCell
    }

    private func categoryCell(at indexPath: IndexPath, with collectionView: UICollectionView, identifier: AnyHashable) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySelectionCell.reuseIdentifier, for: indexPath) as! CategorySelectionCell
        
        cell.selectionView.items = creditSections.map(\.sectionTitle)
        cell.selectionView.didSelectItem = { [unowned self] index in
            self.selectDepartment(at: index)
        }
        
        return cell
    }
    
    private func infoCell(at indexPath: IndexPath, with collectionView: UICollectionView, identifier: AnyHashable) -> UICollectionViewCell {
        if identifier as? String == socialItemId {
            let socialCell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialCell.reuseIdentifier, for: indexPath) as! SocialCell
            socialCell.socialLinks = person.socialLinks
            socialCell.didSelect = openSocialLink
            return socialCell
        } else {
            let infoItem = identifier as! [String: String]
            return collectionView.cell(at: indexPath, model: infoItem, cellConfigurator: InfoListCell.configureWithoutSeparator)
        }
    }
    
    @objc
    private func expandOverview() {
        overviewExpandAction?()
    }
    
    //MARK: - Helpers    
    func credit(at indexPath: IndexPath) -> PersonCreditViewModel? {
        dataSource.itemIdentifier(for: indexPath) as? PersonCreditViewModel
    }
    
    //MARK: - Reload
    private func selectDepartment(at index: Int) {
        selectedCreditSection = creditSections[index]
        if case let .credits(department) = selectedCreditSection {
            willChangeSelectedDepartment?(department)
        }
        reload()
    }
    
    private func setupSections(refresh: Bool = false) {
        sections.removeAll()
        creditSections.removeAll()
        
        if isLoading {
            sections.append(.loading)
        }
        
        if let bio = person.biography, !bio.isEmpty {
            sections.append(.overview)
        }
        
        if !person.information.isEmpty {
            sections.append(.info)
        }
        
        if !person.popularMovies.isEmpty {
            sections.append(.popular)
        }
        
        for job in person.departments {
            creditSections.append(.credits(department: job))
        }
        
        if !creditSections.isEmpty {
            sections.append(.departments)
        }
        
        if refresh && creditSections.count > 0 {
            selectedCreditSection = creditSections.first!
        }
        
        if !creditSections.isEmpty {
            sections.append(selectedCreditSection)
        }
    }
    
    func reloadOverviewSection() {
        isOverviewExpanded = true
        overviewSectionID = UUID().uuidString
        reload(animated: false)
    }
    
    func reload(force: Bool = false, animated: Bool = true) {
        setupSections(refresh: force)
        
        var snapshot = NSDiffableDataSourceSnapshot<PersonDetailDataSource.Section, AnyHashable>()
        snapshot.appendSections(sections)
                
        for section in sections {
            switch section {
            case .loading:
                snapshot.appendItems([loadingItemId], toSection: .loading)
            case .overview:
                snapshot.appendItems([overviewSectionID], toSection: .overview)
            case .popular:
                snapshot.appendItems(person.popularMovies, toSection: .popular)
            case .departments:
                snapshot.appendItems([departmentsSectionID], toSection: .departments)
            case .credits(department: let department):
                let credits = person.credits(for: department)
                snapshot.appendItems(credits, toSection: .credits(department: department))
            case .info:
                if !person.socialLinks.isEmpty {
                    snapshot.appendItems([socialItemId], toSection: .info)
                }
                snapshot.appendItems(person.information, toSection: .info)
            }
        }
        
        if !creditSections.isEmpty, force {
            snapshot.reloadSections([.departments])
        }
    
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
}
