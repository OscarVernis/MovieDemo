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
                return .localized(.Favorites)
            case .Watchlist:
                return .localized(.Watchlist)
            case .Rated:
                return .localized(.Rated)
            }
        }
        
    }
    
    weak var mainCoordinator: MainCoordinator!
    
    var sectionType: Section = .Favorites
    var movies: [MovieViewModel]
    
    init(_ section: Section, movies: [MovieViewModel], coordinator: MainCoordinator) {
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

        let dataProvider: MoviesDataProvider
        switch sectionType {
        case .Favorites:
            dataProvider = MoviesDataProvider(.UserFavorites)
        case .Watchlist:
            dataProvider = MoviesDataProvider(.UserWatchList)
        case .Rated:
            dataProvider = MoviesDataProvider(.UserRated)
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
            MoviePosterTitleRatingCellConfigurator().configure(cell: posterCell, with: movie)

            return posterCell
        } else {
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyMovieCell.reuseIdentifier, for: indexPath) as! EmptyMovieCell

            emptyCell.configure(message: emptyMessageForSection())

            return emptyCell
        }
    }
    
}

//MARK: - Utils
extension UserProfileMovieListSection {
   fileprivate func emptyMessageForSection() -> NSAttributedString {
       var messageString = NSAttributedString()
       switch sectionType {
       case .Favorites:
           let imageAttachment = NSTextAttachment()
           imageAttachment.image = UIImage(systemName: "heart.fill")?.withTintColor(.favoriteColor)

           let fullString = NSMutableAttributedString(string: .localized(.EmptyUserFavorites))
           fullString.append(NSAttributedString(attachment: imageAttachment))
           fullString.append(NSAttributedString(string: .localized(.WillAppearMessage)))
           messageString = fullString
       case .Watchlist:
           let imageAttachment = NSTextAttachment()
           imageAttachment.image = UIImage(systemName: "bookmark.fill")?.withTintColor(.watchlistColor)
           
           let fullString = NSMutableAttributedString(string: .localized(.EmptyUserWatchlist))
           fullString.append(NSAttributedString(attachment: imageAttachment))
           fullString.append(NSAttributedString(string: .localized(.WillAppearMessage)))

           messageString = fullString
           break
       case .Rated:
           let imageAttachment = NSTextAttachment()
           imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.ratingColor)

           let fullString = NSMutableAttributedString(string: .localized(.EmptyUserRated))
           fullString.append(NSAttributedString(attachment: imageAttachment))
           fullString.append(NSAttributedString(string: .localized(.WillAppearMessage)))
           messageString = fullString
           break
       }

       return messageString
   }

}
