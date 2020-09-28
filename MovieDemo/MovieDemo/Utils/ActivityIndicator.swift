//
//  ActivityIndicator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 23/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class ActivityIndicator: UIView {

  var indicator: UIActivityIndicatorView!

  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))

    clipsToBounds = true
    alpha = 0

    indicator = UIActivityIndicatorView()
    indicator.style = .large
    indicator.color = .white
    indicator.startAnimating()

    addSubview(indicator)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    indicator.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
  }
}
