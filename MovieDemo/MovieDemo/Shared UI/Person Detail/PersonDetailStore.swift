//
//  PersonDetailStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class PersonDetailStore: ObservableObject {
    @Published private(set) var person: PersonViewModel
    @Published var error: Error? = nil

    private let service: PersonDetailsLoader?
    
        
    init(person: PersonViewModel, service: PersonDetailsLoader? = nil) {
        self.person = person
        self.service = service
    }
    
    func refresh() {
        guard let service else { return }
         
        service.getPersonDetails(personId: person.id)
            .assignError(to: \.error, on: self)
            .map(PersonViewModel.init(person:))
            .assign(to: &$person)
    }
    
}
