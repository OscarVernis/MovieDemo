//
//  MainCoordinator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

final class MainCoordinator {
    var window: UIWindow
    var rootNavigationViewController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        rootNavigationViewController = UINavigationController()
        rootNavigationViewController?.navigationBar.prefersLargeTitles = true
        rootNavigationViewController?.navigationBar.tintColor = .systemPurple
        rootNavigationViewController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont(name: "AvenirNext-DemiBold", size: 18)!
        ]
        rootNavigationViewController?.navigationBar.standardAppearance.largeTitleTextAttributes = [
            .font: UIFont(name: "AvenirNext-Bold", size: 34)!
        ]
        
        window.rootViewController = rootNavigationViewController
        window.makeKeyAndVisible()
        
        showHome()
    }
    
    func showHome() {
        let hvc = HomeCollectionViewController()
        hvc.mainCoordinator = self
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    func showCrewCreditList<Provider: ArrayDataProvider>(title: String, dataProvider: Provider) {
        let mdvc = ListViewController<Provider, CrewCreditCellConfigurator>()
        mdvc.title = title
        mdvc.dataProvider = dataProvider
        mdvc.dataSource = ListViewDataSource(reuseIdentifier: PhotoCreditListCell.reuseIdentifier, configurator: CrewCreditCellConfigurator())
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showCastCreditList<Provider: ArrayDataProvider>(title: String, dataProvider: Provider) {
        let mdvc = ListViewController<Provider, CastCreditCellConfigurator>()
        mdvc.title = title
        mdvc.dataProvider = dataProvider
        mdvc.dataSource = ListViewDataSource(reuseIdentifier: PhotoCreditListCell.reuseIdentifier, configurator: CastCreditCellConfigurator())
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showMovieList<Provider: ArrayDataProvider>(title: String, dataProvider: Provider) {
        let mdvc = ListViewController<Provider, MovieInfoCellConfigurator>()
        mdvc.title = title
        mdvc.dataProvider = dataProvider
        mdvc.dataSource = ListViewDataSource(reuseIdentifier: MovieInfoCell.reuseIdentifier, configurator: MovieInfoCellConfigurator())
        mdvc.mainCoordinator = self
        
        mdvc.didSelectedItem = { index, movie in
            self.showMovieDetail(movie: movie as! Movie)
        }
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showMovieDetail(movie: Movie) {
        let mdvc = MovieDetailViewController()
        mdvc.movie = MovieViewModel(movie: movie)
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
}
