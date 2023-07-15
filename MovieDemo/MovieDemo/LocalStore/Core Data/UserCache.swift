//
//  UserCache.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import CoreData
import Combine

struct UserCache{
    let store = CoreDataStore.shared
}

extension UserCache: ModelCache  {
    typealias Model = User
    
    func load() throws -> User {
        let fetchRequest = UserMO.fetchRequest()
        let user = try store.context.fetch(fetchRequest).last
        
        return user?.toUser() ?? User()
    }
    
    func save(_ user: User) {
        //Delete previous user cache
        delete()
        
        //Save new user cache
        let _ = UserMO(withUser: user, context: store.context)
        store.save()
    }
    
    func delete() {
        let fetchRequest = UserMO.fetchRequest()
        let items = try? store.context.fetch(fetchRequest)
        
        items?.forEach { store.context.delete($0) }
        
        store.save()
    }
    
}

