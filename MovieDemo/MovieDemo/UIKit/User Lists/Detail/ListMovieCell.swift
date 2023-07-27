//
//  ListMovieCell.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

class ListMovieCell: UITableViewCell {
    enum AccessoryMode {
        case none
        case add
        case loading
        case checkmark
    }
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var addHandler: (() -> ())? = nil
    var deleteHandler: (() -> ())? = nil
    var accessoryMode: AccessoryMode = .none {
        didSet {
            updateAccessoryView()
        }
    }

    
    override func awakeFromNib() {
        posterImageView.setupBorder()
    }
    
    func updateAccessoryView() {
        switch accessoryMode {
        case .none:
            accessoryView = nil
        case .add:
            accessoryView = addButtonAccesoryView
        case .loading:
            accessoryView = loadingAccessoryView
        case .checkmark:
            accessoryView = checkmarkAccesoryView
        }
    }
    
    private var addButtonAccesoryView: UIButton {
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let largeFont = UIFont.systemFont(ofSize: 25)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let addImage = UIImage(systemName: "plus.circle.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
        addButton.setImage(addImage, for: .normal)
        addButton.tintColor = .asset(.RatingColor)
        
        let addAction = UIAction { [unowned self] _ in
            self.addHandler?()
        }
        addButton.addAction(addAction, for: .touchUpInside)
        
        return addButton
    }
    
    private var loadingAccessoryView: UIActivityIndicatorView {
        let actInd = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        actInd.startAnimating()
        return actInd
    }
    
    private var checkmarkAccesoryView: UIButton {
        let checkmarkButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let largeFont = UIFont.boldSystemFont(ofSize: 20)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let addImage = UIImage(systemName: "checkmark", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        checkmarkButton.setImage(addImage, for: .normal)
        checkmarkButton.tintColor = .asset(.RatingColor)
        
        let addAction = UIAction { [unowned self] _ in
            self.deleteHandler?()
        }
        checkmarkButton.addAction(addAction, for: .touchUpInside)
        
        return checkmarkButton
    }
}

extension ListMovieCell {
    static func configure(cell: ListMovieCell, with movie: MovieViewModel) {
        cell.posterImageView.cancelImageRequest()
        cell.posterImageView.image = .asset(.PosterPlaceholder)
        
        if let url = movie.posterImageURL(size: .w342) {
            cell.posterImageView.setRemoteImage(withURL: url, placeholder: .asset(.PosterPlaceholder))
        }
        
        cell.titleLabel.text = movie.title
        
        cell.ratingsView.rating = CGFloat(movie.percentRating)
        cell.ratingsView.isHidden = !movie.isRatingAvailable
        
        cell.overviewLabel.text = movie.overview
        cell.overviewLabel.isHidden = movie.overview.isEmpty
        
        cell.genresLabel.text = movie.genres()
        cell.genresLabel.isHidden = cell.genresLabel.text!.isEmpty
        
        cell.releaseDateLabel.text = movie.releaseYear
        cell.releaseDateLabel.isHidden = movie.releaseYear.isEmpty
    }
}
