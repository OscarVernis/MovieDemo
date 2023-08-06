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
    
    private(set) var shouldReload = false

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
            .onCompletion {
                self.isLoading = false
                self.shouldReload = true
            }
            .assign(to: &$lists)
    }
    
    func addList(name: String, description: String) async {
        do {
            self.shouldReload = false
            let list = try await actionsService.createList(name: name, description: description)
            lists.insert(list, at: 0)
        }
        catch {
            self.error = error
        }
    }

    
    func removeList(at index: Int) async {
        let removedList = lists.remove(at: index)
        do {
            self.shouldReload = false
            try await actionsService.deleteList(listId: removedList.id)
        } catch {
            self.error = error
            lists.insert(removedList, at: index)
        }
    }
    
}