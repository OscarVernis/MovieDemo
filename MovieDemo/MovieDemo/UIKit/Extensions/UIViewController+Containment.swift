//
//  UIViewController+Containment.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIViewController {
    func embed(in parent: UIViewController) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        parent.addChild(self)
        parent.view.addSubview(view)
        didMove(toParent: parent)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parent.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor),
        ])
    }
}
