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
        rootNavigationViewController?.navigationBar.tintColor = .systemPurple
        rootNavigationViewController?.navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemPurple,
            .font: UIFont(name: "AvenirNext-Medium", size: 23)!
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
        let mdvc = MovieListViewController.instantiateFromStoryboard()
        mdvc.title = title
        mdvc.dataProvider = dataProvider
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showMovieDetail(movie: Movie) {
        let mdvc = MovieDetailViewController.instantiateFromStoryboard()
        mdvc.movie = movie
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
}
