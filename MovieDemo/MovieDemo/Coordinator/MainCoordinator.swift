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
    private let isLoginRequired = false
    
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
    
    @MainActor
    func logout() {
        Task {
            let result = await SessionManager.shared.logout()
            
            switch result {
            case .success():
                if self.isLoginRequired {
                    self.showLogin(animated: true)
                }
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                
                self.rootNavigationViewController?.popToRootViewController(animated: true)
            case .failure(_):
                AlertManager.showErrorAlert("Logout error. Please try again.", sender: self.rootNavigationViewController!)
                break
            }
        }
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
    
    func showMovieDetail(movie: MovieViewModel) {
        let mdvc = MovieDetailViewController(movie: movie)
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: true)
    }
    
    func showMovieList(title: String, dataProvider: MoviesDataProvider) {
        let section = DataProviderSection(dataProvider: dataProvider, cellConfigurator: MovieInfoCellConfigurator())
        let lvc = ListViewController(section: section)
        lvc.title = title
        
        rootNavigationViewController?.pushViewController(lvc, animated: true)
        
        lvc.didSelectedItem = { [weak self] index in
            let movie = dataProvider.item(atIndex: index)

            self?.showMovieDetail(movie: movie)
        }

    }
    
    func showPersonProfile(_ viewModel: PersonViewModel) {
        let pvc = PersonDetailViewController.instantiateFromStoryboard()
        pvc.person = viewModel
        pvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(pvc, animated: true)
    }
    
    func showCrewCreditList(title: String, dataProvider: StaticArrayDataProvider<CrewCreditViewModel>) {
        let section = DataProviderSection(dataProvider: dataProvider, cellConfigurator: CrewCreditPhotoListCellConfigurator())
        let lvc = ListViewController(section: section)
        lvc.title = title
        
        lvc.didSelectedItem = { index in
            if index >= dataProvider.itemCount { return }
            
            let crewCredit = dataProvider.item(atIndex: index)
            
            let person = crewCredit.person()
            self.showPersonProfile(person)
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: true)
    }
    
    func showCastCreditList(title: String, dataProvider: StaticArrayDataProvider<CastCreditViewModel>) {
        let section = DataProviderSection(dataProvider: dataProvider, cellConfigurator: CastCreditPhotoListCellConfigurator())
        let lvc = ListViewController(section: section)
        lvc.title = title
        
        lvc.didSelectedItem = { index in
            if index >= dataProvider.itemCount { return }
            
            let castCredit = dataProvider.item(atIndex: index)
            
            let person = castCredit.person()
            self.showPersonProfile(person)
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: true)
    }
    
}
