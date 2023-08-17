//
//  CustomHostingController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit
import SwiftUI

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewWillAppear(_ animated: Bool) {
        configureHomeTitleNavigationBarAppearance()
    }
}
