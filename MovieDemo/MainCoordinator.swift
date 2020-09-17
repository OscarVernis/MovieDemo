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
        let hvc = HomeCollectionViewController.instantiateFromStoryboard()
        hvc.mainCoordinator = self
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    func showMovieList(title: String, dataProvider: MovieListDataProvider) {
//        let mdvc = MovieListViewController.instantiateFromStoryboard()
//        mdvc.title = title
//        mdvc.dataProvider = dataProvider
//        mdvc.mainCoordinator = self
//
//        rootNavigationViewController?.pushViewController(mdvc, animated: true)
        
        let mdvc = ListViewController.instantiateFromStoryboard()
        mdvc.title = title
        mdvc.dataProvider = dataProvider
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showMovieDetail(movie: Movie) {
        let mdvc = MovieDetailViewController.instantiateFromStoryboard()
        mdvc.movie = MovieViewModel(movie: movie)
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
}
