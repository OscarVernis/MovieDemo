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
    
    func load() -> User? {
        let fetchRequest = UserMO.fetchRequest()
        let user = try? store.context.fetch(fetchRequest).last
        
        return user?.toUser()
    }
    
}

extension UserCache: ModelCache  {
    typealias Model = User
    
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

extension UserCache: UserLoader {
    func getUserDetails() -> AnyPublisher<User, Error> {
        let user = load()
        if let user = user {
            return Just(user)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(outputType: User.self, failure: NSError())
                .eraseToAnyPublisher()
        }
    }

}
