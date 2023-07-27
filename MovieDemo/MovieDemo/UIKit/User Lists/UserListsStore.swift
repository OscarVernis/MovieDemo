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
    @Published private(set) var isLoading = false

    let service: UserListsService
    let actionsService: UserListActionsService
    
    init(service: @escaping UserListsService, actionsService: UserListActionsService) {
        self.service = service
        self.actionsService = actionsService
    }
    
    func update() {
        isLoading = true
        
        service(1)
            .assignError(to: \.error, on: self)
            .map(\.lists)
            .onCompletion { self.isLoading = false }
            .assign(to: &$lists)
    }
    
    func addList(name: String, description: String) async {
        do {
            let list = try await actionsService.createList(name: name, description: description)
            lists.insert(list, at: 0)
        }
        catch {
            self.error = error
        }
    }

    
    func delete(list: UserList) async {
        let idx = lists.firstIndex(of: list)
        var removedList: UserList? = nil
        if let idx {
            removedList = lists.remove(at: idx)
        }
        
        do {
            try await actionsService.deleteList(listId: list.id)
        } catch {
            self.error = error
            //            if let removedList, let idx {
            //                lists.insert(removedList, at: idx)
            //            }
        }
    }
    
}
