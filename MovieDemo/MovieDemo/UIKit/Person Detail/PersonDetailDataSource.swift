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
    var person: PersonViewModel
    
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
        dataSources = []
        sections = []
        
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
        
        for job in person.crewJobs {
            let credits = person.credits(for: job)
            dataSources.append(makeCrew(title: job, credits: credits))
            sections.append(.crewCredits)
        }
        
    }
    
    //MARK: - Data Sources
    func makeOverview() -> UICollectionViewDataSource {
        let dataSource = OverviewDataSource(overview: person.biography ?? "")
        
        return dataSource
    }
    
    func makePopular() -> UICollectionViewDataSource {
        makeSection(models: person.popularMovies,
                    title: .localized(PersonString.KnownFor),
                    reuseIdentifier: MoviePosterInfoCell.reuseIdentifier,
                    cellConfigurator: MoviePosterInfoCell.configureWithRating)
    }
    
    func makeCrew(title: String, credits: [PersonCrewCreditViewModel]) -> UICollectionViewDataSource {
        makeSection(models: credits,
                    title: .localized(PersonString.KnownFor),
                    reuseIdentifier: PersonCreditCell.reuseIdentifier,
                    cellConfigurator: PersonCreditCell.configure)
    }
    
    func makeCast() -> UICollectionViewDataSource {
        makeSection(models: person.castCredits,
                           title: .localized(PersonString.Acting),
                           reuseIdentifier: PersonCreditCell.reuseIdentifier,
                           cellConfigurator: PersonCreditCell.configure)
    }
    
    //MARK: Helper
    func makeSection<Model, Cell: UICollectionViewCell>(models: [Model], title: String, reuseIdentifier: String, cellConfigurator: @escaping (Cell, Model) -> Void) -> UICollectionViewDataSource {
        let dataSource = ArrayCollectionDataSource(models: models,
                                                   reuseIdentifier: reuseIdentifier,
                                                   cellConfigurator: cellConfigurator)
        
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
    
    //MARK: - Helper
    func crewCredit(at indexPath: IndexPath) -> PersonCrewCreditViewModel? {
        let titleDataSource = dataSources[indexPath.section] as? TitleHeaderDataSource
        let crewDataSource = titleDataSource?.contentDataSource as? ArrayCollectionDataSource<PersonCrewCreditViewModel, PersonCreditCell>
        
        return crewDataSource?.models[indexPath.row]
    }
    
}
