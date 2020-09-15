//
//  MovieDetailViewController.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/13/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit

class MovieDetailViewController: UITableViewController {
    var movie: Movie? = nil {
        didSet {
            refreshMovie()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refreshMovie() {
        guard let movie = movie else { return }
        
        title = movie.title
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

}
