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
    }
    
    func toUser() -> User {
        let user = User(avatar: self.avatar,
                        username: self.username)
        
        return user
    }
}
