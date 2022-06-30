//
//  CastCreditViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class CastCreditViewModel: Equatable {
    let castCredit: CastCredit
        
    init(castCredit: CastCredit) {
        self.castCredit = castCredit
    }
    
    func person() -> PersonViewModel {
        var person = Person()
        person.id = id
        person.name = name
        person.profilePath = castCredit.profilePath
        
        return PersonViewModel(person: person)
    }
}

extension CastCreditViewModel {
    var id: Int {
        castCredit.id
    }
    
    var name: String {
        castCredit.name
    }
    
    var character: String {
        castCredit.character ?? ""
    }
    
    var profileImageURL: URL? {
        guard let pathString = castCredit.profilePath else { return nil }
        
        return MovieService.profileImageURL(forPath: pathString, size: .h632)
    }
    
}

//MARK: - Hashable
extension CastCreditViewModel: Hashable {
    static func == (lhs: CastCreditViewModel, rhs: CastCreditViewModel) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
