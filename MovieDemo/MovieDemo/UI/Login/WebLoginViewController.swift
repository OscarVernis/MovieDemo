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
    let sessionManager = SessionManager.shared
    
    var showsCloseButton: Bool = true
    var didFinishLoginProcess: (() -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        Task { await showWebLogin() }
    }
    
    func showWebLogin() async {
        let token = try? await service.requestToken()
        
        guard let token = token else { return }
        
        let urlString = "https://www.themoviedb.org/authenticate/\(token)?redirect_to=moviedemoauth://"
        guard let authURL = URL(string: urlString) else { return }
        let scheme = "moviedemoauth"

        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }
            
            print(callbackURL)

            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            let denied = queryItems?.filter({ $0.name == "denied" }).first?.value
            let approved = queryItems?.filter({ $0.name == "approved" }).first?.value

            if approved == "true" {
                print("Approved")
            }
            
            Task {
                let sessionId = try? await self.service.createSession(requestToken: token)
                guard let sessionId = sessionId else { return }
                print(sessionId)
                self.sessionManager.save(sessionId: sessionId)
                self.didFinishLoginProcess?()
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
