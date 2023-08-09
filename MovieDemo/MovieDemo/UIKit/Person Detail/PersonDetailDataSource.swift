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
        case castCredits
        case crewCredits(department: String)
        case info
        
        var sectionTitle: String {
            switch self {
            case .overview, .info, .loading:
                return ""
            case .popular:
                return .localized(PersonString.KnownFor)
            case .departments:
                return .localized(PersonString.Credits)
            case .castCredits:
                return .localized(PersonString.Acting)
            case .crewCredits(department: let department):
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
    var selectedCreditSection: Section = .castCredits
    
    var willChangeSelectedDepartment: ((Section) -> Void)? = nil
    
    init(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
            
            self.cell(for: collectionView, with: indexPath, identifier: itemIdentifier)
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
    
    func cell(for collectionView: UICollectionView, with indexPath: IndexPath, identifier: AnyHashable) -> UICollectionViewCell {
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
        case .castCredits:
            let castCredit = identifier as! PersonCastCreditViewModel
            return collectionView.cell(at: indexPath, model: castCredit, cellConfigurator: PersonCreditCell.configure)
        case .crewCredits:
            let crewCredit = identifier as! PersonCrewCreditViewModel
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
            return collectionView.cell(at: indexPath, model: infoItem, cellConfigurator: { (cell: InfoListCell, infoItem) in
                InfoListCell.configure(cell: cell, info: infoItem)
                cell.separator.isHidden = true
            })
        }
    }
    
    @objc
    private func expandOverview() {
        overviewExpandAction?()
    }
    
    //MARK: - Helpers
    func itemCount(for section: Section) -> Int {
        switch section {
        case .castCredits:
            return person.castCredits.isEmpty ? 0 : person.castCredits.count
        case .crewCredits(department: let department):
            return person.credits(for: department).count
        default:
            return 0
        }
    }
    
    func crewCredit(at indexPath: IndexPath) -> PersonCrewCreditViewModel? {
        dataSource.itemIdentifier(for: indexPath) as? PersonCrewCreditViewModel
    }
    
    //MARK: - Reload
    private func selectDepartment(at index: Int) {
        selectedCreditSection = creditSections[index]
        willChangeSelectedDepartment?(selectedCreditSection)
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
                
        if !person.castCredits.isEmpty {
            creditSections.append(.castCredits)
        }
        
        for job in person.departments {
            creditSections.append(.crewCredits(department: job))
        }
        
        if !creditSections.isEmpty {
            sections.append(.departments)
        }
        
        //Send Acting to the end if person is know for crew department
        if person.departments.first == person.knownForDepartment,
           creditSections.first == .castCredits {
            let section = creditSections.remove(at: 0)
            creditSections.append(section)
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
            case .castCredits:
                snapshot.appendItems(person.castCredits, toSection: .castCredits)
            case .crewCredits(department: let department):
                let credits = person.credits(for: department)
                snapshot.appendItems(credits, toSection: .crewCredits(department: department))
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
