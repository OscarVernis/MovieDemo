//
//  UIViewController+CustomBackButton.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 25/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupCustomBackButton() {
        let backButton = BlurButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        backButton.setImage(.asset(.back), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        //Fixes back gesture not working after setting custom back button
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

