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

    private let service: PersonDetailsService?
        
    init(person: PersonViewModel, service: @autoclosure @escaping PersonDetailsService) {
        self.person = person
        self.service = service
    }
    
    init(person: PersonViewModel) {
        self.person = person
        self.service = nil
    }
    
    func refresh() {
        guard let service else { return }
         
        service()
            .assignError(to: \.error, on: self)
            .map(PersonViewModel.init(person:))
            .assign(to: &$person)
    }
    
}
