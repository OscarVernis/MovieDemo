//
//  WebLoginViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
import AuthenticationServices

class WebLoginViewController: UIViewController {
    let service = RemoteSessionService()
    var sessionManager: SessionManager!
    var router: LoginRouter? = nil
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    var showsCloseButton: Bool = true

    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        closeButton.isHidden = !showsCloseButton
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 8
    }
    
    //MARK: - Actions
    @IBAction func closeTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        Task { await startWebLogin() }
    }
    
    //MARK: - Login
    func startWebLogin() async {
        var token: String = ""
        do {
            token = try await service.requestToken()
        } catch {
            router?.handle(error: .loginError)
            return
        }
                
        let urlString = "https://www.themoviedb.org/authenticate/\(token)?redirect_to=moviedemoauth://"
        let authURL = URL(string: urlString)!
        let scheme = "moviedemoauth"

        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }
            
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            let approved = queryItems?.filter({ $0.name == "approved" }).first?.value
            
            if approved != "true"{
                self.router?.handle(error: .loginError)
                return
            }
            
            Task {
                let sessionId = try? await self.service.createSession(requestToken: token)
                guard let sessionId = sessionId else {
                    self.router?.handle(error: .loginError)
                    return
                }
                
                self.sessionManager.save(sessionId: sessionId)
                self.router?.didFinishLoginProcess()
            }
        }
        
        session.presentationContextProvider = self
        session.start()
    }

}

extension WebLoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
