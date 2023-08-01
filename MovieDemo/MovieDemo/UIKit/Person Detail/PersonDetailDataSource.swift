//
//  PersonDetailDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonDetailDataSource: UICollectionViewDiffableDataSource<PersonDetailDataSource.Section, AnyHashable> {
    enum Section: Hashable {
        case overview
        case popular
        case creditCategories
        case castCredits
        case crewCredits(department: String)
        case info
        
        var sectionTitle: String {
            switch self {
            case .overview, .info:
                return ""
            case .popular:
                return .localized(PersonString.KnownFor)
            case .creditCategories:
                return .localized(PersonString.Credits)
            case .castCredits:
                return .localized(PersonString.Acting)
            case .crewCredits(department: let department):
                return department
            }
        }
        
    }
    
    var person: PersonViewModel!
    
    var overviewSectionID = UUID().uuidString
    var isOverviewExpanded: Bool = false
    var overviewExpandAction: (() -> ())?
    
    var socialItemId = UUID().uuidString
    var openSocialLink: ((SocialLink) -> ())?
    
    var sections: [Section] = []
    var creditSections: [Section] = []
    var selectedCreditSection: Section = .castCredits
    
    //MARK: - Setup
    func registerReusableViews(collectionView: UICollectionView) {
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        OverviewCell.register(to: collectionView)
        PersonCreditCell.register(to: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
        CategoryCell.register(to: collectionView)
        InfoListCell.register(to: collectionView)
        SocialCell.register(to: collectionView)
    }
    
    func cell(for collectionView: UICollectionView, with indexPath: IndexPath, identifier: AnyHashable) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        let section = sections[indexPath.section]
        
        switch section {
        case .overview:
            let overviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.reuseIdentifier, for: indexPath) as! OverviewCell
            overviewCell.textLabel.text = person.biography
            overviewCell.isExpanded = isOverviewExpanded
            overviewCell.expandButton.addTarget(self, action: #selector(expandOverview), for: .touchUpInside)
            cell = overviewCell
        case .popular:
            let movie = identifier as! MovieViewModel
            let popularCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
            MoviePosterInfoCell.configureWithRating(cell: popularCell, with: movie)
            cell = popularCell
        case .creditCategories:
            let credit = identifier as! Section
            let title = credit.sectionTitle
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
            categoryCell.titleLabel.text = title
            let selected = selectedCreditSection == creditSections[indexPath.row]
            categoryCell.setSelection(selected)
            cell = categoryCell
        case .castCredits:
            let castCredit = identifier as! PersonCastCreditViewModel
            let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCreditCell.reuseIdentifier, for: indexPath) as! PersonCreditCell
            PersonCreditCell.configure(cell: castCell, castCredit: castCredit)
            cell = castCell
        case .crewCredits:
            let crewCredit = identifier as! PersonCrewCreditViewModel
            let crewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCreditCell.reuseIdentifier, for: indexPath) as! PersonCreditCell
            PersonCreditCell.configure(cell: crewCell, crewCredit: crewCredit)
            cell = crewCell
        case .info:
            if identifier as? String == socialItemId {
                let socialCell = collectionView.dequeueReusableCell(withReuseIdentifier: SocialCell.reuseIdentifier, for: indexPath) as! SocialCell
                socialCell.socialLinks = person.socialLinks
                socialCell.didSelect = openSocialLink
                cell = socialCell
            } else {
                let infoItem = identifier as! [String: String]
                let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoListCell.reuseIdentifier, for: indexPath) as! InfoListCell
                InfoListCell.configure(cell: infoCell, info: infoItem)
                infoCell.separator.isHidden = true
                cell = infoCell
            }
        }
        
        return cell
    }
    
    @objc
    private func expandOverview() {
        overviewExpandAction?()
    }
    
    //MARK: - Helpers
    var indexPathForSelectedCreditSection: IndexPath? {
        let section = sections.firstIndex(of: .creditCategories)
        let row = creditSections.firstIndex(of: selectedCreditSection)
        
        if let section, let row {
            return IndexPath(row: row, section: section)
        } else {
            return nil
        }
    }
    
    var sectionForCredits: Int? {
        sections.firstIndex(of: selectedCreditSection)
    }
    
    func itemCount(for section: Section) -> Int {
        switch section {
        case .overview:
            return person.biography?.isEmpty ?? true ? 0 : 1
        case .popular:
            return person.popularMovies.isEmpty ? 0 : person.popularMovies.count
        case .creditCategories:
            return creditSections.count
        case .castCredits:
            return person.castCredits.isEmpty ? 0 : person.castCredits.count
        case .crewCredits(department: let department):
            return person.credits(for: department).count
        case .info:
            return person.information.count
        }
    }
    
    func crewCredit(at indexPath: IndexPath) -> PersonCrewCreditViewModel? {
        itemIdentifier(for: indexPath) as? PersonCrewCreditViewModel
    }
    
    //MARK: - Reload
    func setupSections(refresh: Bool = false) {
        sections.removeAll()
        creditSections.removeAll()
        
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
            sections.append(.creditCategories)
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
        sections.append(selectedCreditSection)
        
        
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
            case .overview:
                snapshot.appendItems([overviewSectionID], toSection: .overview)
            case .popular:
                snapshot.appendItems(person.popularMovies, toSection: .popular)
            case .creditCategories:
                snapshot.appendItems(creditSections, toSection: .creditCategories)
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
    
        self.apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: - Collection View
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.sections[indexPath.section]
        
        guard let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as? SectionTitleView  else { fatalError() }
        
        let title = section.sectionTitle
        SectionTitleView.configureForDetail(headerView: sectionTitleView, title: title)
        
        return sectionTitleView
    }
    
}
