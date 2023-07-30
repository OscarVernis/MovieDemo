//
//  PersonDetailDiffableDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonDetailDiffableDataSource: UICollectionViewDiffableDataSource<PersonDetailDiffableDataSource.Section, AnyHashable> {
    enum Section: Hashable {
        case overview
        case popular
        case castCredits
        case crewCredits(job: String)
        
        var sectionTitle: String {
            switch self {
            case .overview:
                return ""
            case .popular:
                return .localized(PersonString.KnownFor)
            case .castCredits:
                return .localized(PersonString.Acting)
            case .crewCredits(job: let job):
                return job
            }
        }
    }
    
    var overviewSectionID = UUID().uuidString
    
    var person: PersonViewModel!
    var sections: [Section] = []
    
    func registerReusableViews(collectionView: UICollectionView) {
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        OverviewCell.register(to: collectionView)
        PersonCreditCell.register(to: collectionView)
        PersonCreditCell.register(to: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
    }
    
    func cellRegistration() -> UICollectionViewDiffableDataSource<PersonDetailDiffableDataSource.Section, AnyHashable>.CellProvider {
        return { [weak self] collectionView, indexPath, identifier in
            guard let self else { fatalError() }
            
            let cell: UICollectionViewCell
            let section = self.sections[indexPath.section]
            
            switch section {
            case .overview:
                let overviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OverviewCell.reuseIdentifier, for: indexPath) as! OverviewCell
                overviewCell.textLabel.text = person.biography
                cell = overviewCell
            case .popular:
                let movie = identifier as! MovieViewModel
                let popularCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell
                MoviePosterInfoCell.configureWithRating(cell: popularCell, with: movie)
                cell = popularCell
            case .castCredits:
                let castCredit = identifier as! PersonCastCreditViewModel
                let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCreditCell.reuseIdentifier, for: indexPath) as! PersonCreditCell
                PersonCreditCell.configure(cell: castCell, castCredit: castCredit)
                cell = castCell
            case .crewCredits(job: _):
                let crewCredit = identifier as! PersonCrewCreditViewModel
                let crewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCreditCell.reuseIdentifier, for: indexPath) as! PersonCreditCell
                PersonCreditCell.configure(cell: crewCell, crewCredit: crewCredit)
                cell = crewCell
            }
            
            return cell
        }
    }
    
    func setupSections() {
        sections.removeAll()
        
        if let bio = person.biography, !bio.isEmpty {
            sections.append(.overview)
        }
        
        if !person.popularMovies.isEmpty {
            sections.append(.popular)
        }
        
        if !person.castCredits.isEmpty {
            sections.append(.castCredits)
        }
        
        for job in person.crewJobs {
            sections.append(.crewCredits(job: job))
        }
    }
    
    func reload(animated: Bool = true) {
        setupSections()
        
        var snapshot = NSDiffableDataSourceSnapshot<PersonDetailDiffableDataSource.Section, AnyHashable>()
        snapshot.appendSections(sections)
        
        for section in sections {
            switch section {
            case .overview:
                snapshot.appendItems([overviewSectionID], toSection: .overview)
            case .popular:
                snapshot.appendItems(person.popularMovies, toSection: .popular)
            case .castCredits:
                snapshot.appendItems(person.castCredits, toSection: .castCredits)
            case .crewCredits(job: let job):
                let credits = person.credits(for: job)
                snapshot.appendItems(credits, toSection: .crewCredits(job: job))
            }
        }
        
        apply(snapshot, animatingDifferences: animated)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.sections[indexPath.section]
        
        guard let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as? SectionTitleView  else { fatalError() }
        
        let title = section.sectionTitle
        SectionTitleView.configureForDetail(headerView: sectionTitleView, title: title)
        
        return sectionTitleView
    }
    
    func crewCredit(at indexPath: IndexPath) -> PersonCrewCreditViewModel? {
        itemIdentifier(for: indexPath) as? PersonCrewCreditViewModel
    }
    
}
