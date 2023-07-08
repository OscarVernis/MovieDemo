//
//  PersonDetailStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

class PersonDetailStore: ObservableObject {
    @Published var person: PersonViewModel
    private let service: PersonDetailsLoader?
    
    private(set) var isLoading = false
    @Published var error: Error? = nil
    
    init(person: PersonViewModel, service: PersonDetailsLoader? = nil) {
        self.person = person
        self.service = service
    }
    
    func refresh() {
        guard let service else { return }
        
        service.getPersonDetails(personId: person.id).completion { [weak self] result in
            switch result {
            case .success(let person):
                self?.person = PersonViewModel(person: person)
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
}
