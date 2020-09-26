//
//  MainCoordinator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

final class MainCoordinator {
    private var window: UIWindow
    private var rootNavigationViewController: UINavigationController?
    
    //If set to true, it will force you to login before showing Home
    private let isLoginRequired = true
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        rootNavigationViewController = UINavigationController()
        rootNavigationViewController?.navigationBar.prefersLargeTitles = true
        rootNavigationViewController?.navigationBar.tintColor = .appTintColor
        rootNavigationViewController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)!
        ]
        rootNavigationViewController?.navigationBar.standardAppearance.largeTitleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-Bold", size: 34)!,
        ]
        
        window.rootViewController = rootNavigationViewController
        window.makeKeyAndVisible()
        
        if isLoginRequired && SessionManager.shared.isLoggedIn == false {
            showLogin(animated: false)
        } else {
            showHome()
        }
        
    }
    
    func showLogin(animated: Bool = true) {
        let lvc = LoginViewController.instantiateFromStoryboard()
        lvc.showsCloseButton = !isLoginRequired
        if isLoginRequired {
            lvc.modalPresentationStyle = .overFullScreen
        }
        
        lvc.didFinishLoginProcess = { [weak self] success in
            self?.rootNavigationViewController?.dismiss(animated: true)
        }
        
        rootNavigationViewController?.present(lvc, animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            
            if self.isLoginRequired && self.rootNavigationViewController!.viewControllers.isEmpty {
                self.showHome()
            }
        })
    }
    
    func logout() {
        SessionManager.shared.logout()
        
        if isLoginRequired {
            showLogin(animated: true)
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        rootNavigationViewController?.popToRootViewController(animated: true)
    }
    
    func showUserProfile() {
        if !SessionManager.shared.isLoggedIn {
            showLogin()
        } else {
            let upvc = UserProfileViewController()
            upvc.mainCoordinator = self
            
            rootNavigationViewController?.pushViewController(upvc, animated: true)
        }
    }
    
    func showHome() {
        let hvc = HomeCollectionViewController()
        hvc.mainCoordinator = self
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    func showMovieDetail(movie: Movie) {
        let mdvc = MovieDetailViewController(viewModel: MovieViewModel(movie: movie))
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showMovieList<Provider: ArrayDataProvider>(title: String, dataProvider: Provider) {
        let mdvc = ListViewController<Provider, MovieInfoCellConfigurator>()
        mdvc.title = title
        mdvc.dataProvider = dataProvider
        mdvc.dataSource = ListViewDataSource(reuseIdentifier: MovieInfoListCell.reuseIdentifier, configurator: MovieInfoCellConfigurator())
        mdvc.mainCoordinator = self
        
        mdvc.didSelectedItem = { [weak self] index, movie in
            self?.showMovieDetail(movie: movie as! Movie)
        }
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showCrewCreditList<Provider: ArrayDataProvider>(title: String, dataProvider: Provider) {
        let mdvc = ListViewController<Provider, CrewCreditPhotoListCellConfigurator>()
        mdvc.title = title
        mdvc.dataProvider = dataProvider
        mdvc.dataSource = ListViewDataSource(reuseIdentifier: CreditPhotoListCell.reuseIdentifier, configurator: CrewCreditPhotoListCellConfigurator())
        mdvc.mainCoordinator = self
        
        mdvc.didSelectedItem = { [weak self] index, crewCredit in
            guard let crewCredit = crewCredit as? CrewCreditViewModel, let self = self else { return }
            
            let dataProvider = MovieListDataProvider(.DiscoverWithCrew(crewId: crewCredit.id))
            let title = "Movies by: \(crewCredit.name)"
            self.showMovieList(title: title, dataProvider: dataProvider)
        }
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showCastCreditList<Provider: ArrayDataProvider>(title: String, dataProvider: Provider) {
        let mdvc = ListViewController<Provider, CastCreditPhotoListCellConfigurator>()
        mdvc.title = title
        mdvc.dataProvider = dataProvider
        mdvc.dataSource = ListViewDataSource(reuseIdentifier: CreditPhotoListCell.reuseIdentifier, configurator: CastCreditPhotoListCellConfigurator())
        mdvc.mainCoordinator = self
        
        mdvc.didSelectedItem = { [weak self] index, castCredit in
            guard let castCredit = castCredit as? CastCreditViewModel, let self = self else { return }
            
            let dataProvider = MovieListDataProvider(.DiscoverWithCast(castId: castCredit.id))
            let title = "Movies with: \(castCredit.name)"
            self.showMovieList(title: title, dataProvider: dataProvider)
        }
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
}
