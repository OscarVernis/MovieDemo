//
//  UserProfileMovieListSection.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

class UserProfileMovieListSection: ConfigurableSection {
    enum Section: Int, CaseIterable {
        case Favorites
        case Watchlist
        case Rated
        
        var title: String {
            switch self {
            case .Favorites:
                return NSLocalizedString("Favorites", comment: "")
            case .Watchlist:
                return NSLocalizedString("Watchlist", comment: "")
            case .Rated:
                return NSLocalizedString("Rated", comment: "")
            }
        }
        
    }
    
    weak var mainCoordinator: MainCoordinator!
    
    var sectionType: Section = .Favorites
    var movies: [Movie]
    
    init(_ section: Section, movies: [Movie], coordinator: MainCoordinator) {
        self.sectionType = section
        self.movies = movies
        self.mainCoordinator = coordinator
    }
    
    var itemCount: Int {
        return movies.count == 0 ? 1 : movies.count
    }
    
    func registerReusableViews(withCollectionView collectionView: UICollectionView) {
        SectionTitleView.registerHeader(withCollectionView: collectionView)
        MoviePosterInfoCell.register(withCollectionView: collectionView)
        EmptyMovieCell.register(withCollectionView: collectionView)
    }
    
    func sectionLayout() -> NSCollectionLayoutSection {
        let sectionBuilder = MoviesCompositionalLayoutBuilder()
        
        let section: NSCollectionLayoutSection

        if movies.count > 0 {
            section = sectionBuilder.createHorizontalPosterSection()
        } else {
            section = sectionBuilder.createSection(groupHeight: .estimated(260))
            section.contentInsets.top = 10
            section.contentInsets.bottom = 20
        }
        
        
        let sectionHeader = sectionBuilder.createTitleSectionHeader()
        section.contentInsets.top = 12
        section.contentInsets.bottom = 10
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func reusableView(withCollectionView collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.reuseIdentifier, for: indexPath) as! SectionTitleView

        let dataProvider: MovieListDataProvider
        switch sectionType {
        case .Favorites:
            dataProvider = MovieListDataProvider(.UserFavorites)
        case .Watchlist:
            dataProvider = MovieListDataProvider(.UserWatchList)
        case .Rated:
            dataProvider = MovieListDataProvider(.UserRated)
        }
        
        var tapHandler: (() -> ())? = nil
        if movies.count > 0 {
            tapHandler = { [weak self] in
                guard let self = self else { return }

                self.mainCoordinator.showMovieList(title: self.sectionType.title, dataProvider: dataProvider)
            }
        }

        MovieDetailTitleSectionConfigurator().configure(headerView: headerView, title: sectionType.title, tapHandler: tapHandler)

        return headerView
    }
    
    func cell(withCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if movies.count > 0 {
            let posterCell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterInfoCell.reuseIdentifier, for: indexPath) as! MoviePosterInfoCell

            let movie = movies[indexPath.row]
            MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: MovieViewModel(movie: movie))

            return posterCell
        } else {
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyMovieCell.reuseIdentifier, for: indexPath) as! EmptyMovieCell

            emptyCell.configure(message: emptyMessageForSection())

            return emptyCell
        }
    }
    
}

//MARK: Utils
extension UserProfileMovieListSection {
   fileprivate func emptyMessageForSection() -> NSAttributedString {
       var messageString = NSAttributedString()
       switch sectionType {
       case .Favorites:
           let imageAttachment = NSTextAttachment()
           imageAttachment.image = UIImage(systemName: "heart.fill")?.withTintColor(.favoriteColor)

           let fullString = NSMutableAttributedString(string: NSLocalizedString("Movies you mark as Favorite ", comment: ""))
           fullString.append(NSAttributedString(attachment: imageAttachment))
           fullString.append(NSAttributedString(string: NSLocalizedString(" will appear here.", comment: "")))
           messageString = fullString
       case .Watchlist:
           let imageAttachment = NSTextAttachment()
           imageAttachment.image = UIImage(systemName: "bookmark.fill")?.withTintColor(.watchlistColor)
           let fullString = NSMutableAttributedString(string: NSLocalizedString("Movies you add to your Watchlist ", comment: ""))
           fullString.append(NSAttributedString(attachment: imageAttachment))
           fullString.append(NSAttributedString(string: NSLocalizedString(" will appear here.", comment: "")))

           messageString = fullString
           break
       case .Rated:
           let imageAttachment = NSTextAttachment()
           imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.ratingColor)

           let fullString = NSMutableAttributedString(string: NSLocalizedString("Movies you rate ", comment: ""))
           fullString.append(NSAttributedString(attachment: imageAttachment))
           fullString.append(NSAttributedString(string: NSLocalizedString(" will appear here.", comment: "")))
           messageString = fullString
           break
       }

       return messageString
   }

}
