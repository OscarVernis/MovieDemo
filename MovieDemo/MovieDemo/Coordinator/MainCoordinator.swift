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
    private(set) var rootNavigationViewController: UINavigationController?
    
    private var sessionManager = SessionManager.shared
    
    //If set to true, it will force you to login before showing Home
    private let isLoginRequired: Bool
    
    init(window: UIWindow, isLoginRequired: Bool = false) {
        self.window = window
        self.isLoginRequired = isLoginRequired
    }
    
    func handle(error: UserFacingError, completion: (() -> Void)? = nil) {
        guard let sender = rootNavigationViewController else { return }
        
        AlertManager.showErrorAlert(error.localizedDescription,
                                    color: error.alertColor,
                                    image: error.alertImage,
                                    sender: sender,
                                    completion: completion)
    }
    
    func start() {
        rootNavigationViewController = UINavigationController()
        rootNavigationViewController?.navigationBar.prefersLargeTitles = true
        rootNavigationViewController?.navigationBar.tintColor = .asset(.AppTintColor)
        rootNavigationViewController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)!
        ]
        rootNavigationViewController?.navigationBar.standardAppearance.largeTitleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-Bold", size: 34)!,
        ]
        
        window.rootViewController = rootNavigationViewController
        window.makeKeyAndVisible()
        
        if isLoginRequired && sessionManager.isLoggedIn == false {
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
        
        lvc.didFinishLoginProcess = { [weak self] in
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
    func logout(completion: (() -> Void)? = nil) {
        Task {
            let result = await sessionManager.logout()
            
            switch result {
            case .success():
                if self.isLoginRequired {
                    self.showLogin(animated: true)
                }
                
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                
                self.rootNavigationViewController?.popToRootViewController(animated: true)
                completion?()
            case .failure(let error):
                handle(error: error)
                completion?()
            }
        }
    }
    
    func showUserProfile(animated: Bool = true) {
        if !sessionManager.isLoggedIn {
            showLogin(animated: animated)
        } else {
            let upvc = UserProfileViewController()
            upvc.mainCoordinator = self
            
            rootNavigationViewController?.pushViewController(upvc, animated: animated)
        }
    }
    
    func showHome() {
        let hvc = HomeViewController()
        hvc.mainCoordinator = self
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        let mdvc = MovieDetailViewController(movie: movie)
        mdvc.mainCoordinator = self
        
        rootNavigationViewController?.pushViewController(mdvc, animated: animated)
    }
    
    func showMovieList<T: ArrayDataProvider>(title: String, dataProvider: T, animated: Bool = true) where T.Model == MovieViewModel {
        let section = DataProviderSection(dataProvider: dataProvider, cellConfigurator: MovieInfoCellConfigurator())
        let lvc = ListViewController(section: section, coordinator: self)
        lvc.title = title
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
        
        lvc.didSelectedItem = { [weak self] index in
            if index >= dataProvider.itemCount { return }

            let movie = dataProvider.item(atIndex: index)
            self?.showMovieDetail(movie: movie)
        }

    }
    
    func showPersonProfile(_ viewModel: PersonViewModel, animated: Bool = true) {
        let pvc = PersonDetailViewController.instantiateFromStoryboard()
        pvc.person = viewModel
        pvc.mainCoordinator = self
                        
        rootNavigationViewController?.pushViewController(pvc, animated: animated)
    }
    
    func showCrewCreditList(title: String, dataProvider: StaticArrayDataProvider<CrewCreditViewModel>, animated: Bool = true) {
        let section = DataProviderSection(dataProvider: dataProvider, cellConfigurator: CrewCreditPhotoListCellConfigurator())
        let lvc = ListViewController(section: section, coordinator: self)
        lvc.title = title
        
        lvc.didSelectedItem = { index in
            if index >= dataProvider.itemCount { return }
            
            let crewCredit = dataProvider.item(atIndex: index)
            
            let person = crewCredit.person()
            self.showPersonProfile(person)
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
    }
    
    func showCastCreditList(title: String, dataProvider: StaticArrayDataProvider<CastCreditViewModel>, animated: Bool = true) {
        let section = DataProviderSection(dataProvider: dataProvider, cellConfigurator: CastCreditPhotoListCellConfigurator())
        let lvc = ListViewController(section: section, coordinator: self)
        lvc.title = title
        
        lvc.didSelectedItem = { index in
            if index >= dataProvider.itemCount { return }
            
            let castCredit = dataProvider.item(atIndex: index)
            
            let person = castCredit.person()
            self.showPersonProfile(person)
        }
        
        rootNavigationViewController?.pushViewController(lvc, animated: animated)
    }
    
}
