//
//  PersonDetailDataSource.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 13/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit

class PersonDetailDataSource: SectionedCollectionDataSource {
    enum Section: Int, CaseIterable {
        case overview
        case popular
        case castCredits
        case crewCredits
    }
    
    unowned var collectionView: UICollectionView
    let person: PersonViewModel
    
    var sections: [Section] = []
    
    init(collectionView: UICollectionView, person: PersonViewModel) {
        self.collectionView = collectionView
        self.person = person
        
        super.init()
        
        registerReusableViews()
        setupDataSources()
    }
    
    func reload() {
        setupDataSources()
    }
    
    //MARK: - Setup
    func registerReusableViews() {
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        OverviewCell.register(to: collectionView)
        PersonCreditCell.register(to: collectionView)
        PersonCreditCell.register(to: collectionView)
        MoviePosterInfoCell.register(to: collectionView)
    }
    
    func setupDataSources() {
        if let bio = person.biography, !bio.isEmpty {
            dataSources.append(makeOverview())
            sections.append(.overview)
        }
        
        if !person.popularMovies.isEmpty {
            dataSources.append(makePopular())
            sections.append(.popular)
        }
        
        if !person.castCredits.isEmpty {
            dataSources.append(makeCast())
            sections.append(.castCredits)
        }
        
        let crewGrouping = Dictionary(grouping: person.crewCredits, by: \.job)
        for (key, credits) in crewGrouping {
            dataSources.append(makeCrew(title: key ?? "", credits: credits))
            sections.append(.crewCredits)
        }
        
    }
    
    //MARK: - Data Sources
    func makeOverview() -> UICollectionViewDataSource {
        let dataSource = OverviewDataSource(overview: person.biography ?? "")
        
        return dataSource
    }
    
    func makePopular() -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: person.popularMovies,
                                                   reuseIdentifier: MoviePosterInfoCell.reuseIdentifier,
                                                   cellConfigurator: MoviePosterInfoCell.configureWithRating)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(PersonString.KnownFor),
                                                    dataSource: dataSource)
        
        return titleDataSource
    }
    
    func makeCrew(title: String, credits: [PersonCrewCreditViewModel]) -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: credits,
                                                   reuseIdentifier: PersonCreditCell.reuseIdentifier,
                                                   cellConfigurator: PersonCreditCell.configure)
        
        let titleDataSource = TitleHeaderDataSource(title: title,
                                                    dataSource: dataSource)
        
        return titleDataSource
        
    }
    
    func makeCast() -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: person.castCredits,
                                                   reuseIdentifier: PersonCreditCell.reuseIdentifier,
                                                   cellConfigurator: PersonCreditCell.configure)
        
        let titleDataSource = TitleHeaderDataSource(title: .localized(PersonString.Acting),
                                                    dataSource: dataSource)
        
        return titleDataSource    }
    
    func makeTitleHeader(title: String, dataSource: UICollectionViewDataSource) -> UICollectionViewDataSource {
        let titleDataSource = TitleHeaderDataSource(title: title,
                                                    dataSource: dataSource,
                                                    headerConfigurator: SectionTitleView.configureForDetail)
        
        return titleDataSource
    }
    
    //MARK: - Header Data Source
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: 0)

        return dataSource.collectionView!(collectionView, viewForSupplementaryElementOfKind: kind, at:indexPath)
    }
    
}
