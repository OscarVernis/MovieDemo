//
//  UserListsStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class UserListsStore {
    @Published var lists: [UserList] = []
    @Published var error: Error? = nil
    
    let service: UserListsService
    let actionsService: UserListActionsService
    private(set) var isLoading = false
    
    init(service: @escaping UserListsService, actionsService: UserListActionsService) {
        self.service = service
        self.actionsService = actionsService
    }
    
    func update() {
        service(1)
            .assignError(to: \.error, on: self)
            .map(\.lists)
            .assign(to: &$lists)
    }
    
    func addList(name: String, description: String) async throws {
        let list = try await actionsService.createList(name: name, description: description)
        lists.insert(list, at: 0)
    }
    
    func delete(list: UserList) async throws {
        let idx = lists.firstIndex(of: list)
        var removedList: UserList? = nil
        if let idx {
            removedList = lists.remove(at: idx)
        }
        
        do {
            try await actionsService.delete(listId: list.id)
        } catch {
            if let removedList, let idx {
                lists.insert(removedList, at: idx)
            }
        }
    }
    
}
