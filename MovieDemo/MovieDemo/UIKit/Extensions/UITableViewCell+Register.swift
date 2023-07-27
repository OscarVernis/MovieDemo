//
//  UITableViewCell+Register.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static func register(to tableView: UITableView) {
        tableView.register(namedNib(), forCellReuseIdentifier: reuseIdentifier)
    }
}
