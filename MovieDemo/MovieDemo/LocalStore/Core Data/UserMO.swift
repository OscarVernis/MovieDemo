//
//  UserMO.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserMO)
public class UserMO: NSManagedObject {
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(withUser user: User, context: NSManagedObjectContext) {
        super.init(entity: Self.entity(), insertInto: context)
        
        self.username = user.username
        self.avatar = user.avatar
        addToFavorites(NSOrderedSet(array: user.favorites.map { MovieMO(withMovie: $0, context: context) }))
        addToWatchlist(NSOrderedSet(array: user.watchlist.map { MovieMO(withMovie: $0, context: context) }))
        addToRated(NSOrderedSet(array: user.rated.map { MovieMO(withMovie: $0, context: context) }))
    }
    
    func toUser() -> User {
        let favorites = (self.favorites?.array as? [MovieMO])?.compactMap( { $0.toMovie() }) ?? []
        let watchlist = (self.watchlist?.array as? [MovieMO])?.compactMap { $0.toMovie() } ?? []
        let rated = (self.rated?.array as? [MovieMO])?.compactMap { $0.toMovie() } ?? []

        let user = User(avatar: self.avatar,
                        username: self.username,
                        favorites: favorites,
                        watchlist: watchlist,
                        rated: rated)
        
        return user
    }
}
