//
//  PersonCreditConfigurator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/10/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct PersonCreditConfigurator {
    func configure(cell: PersonCreditCell, castCredit: PersonCastCreditViewModel) {
        cell.yearLabel.text = castCredit.year
        cell.titleLabel.text = castCredit.title
        
        cell.creditLabel.text = castCredit.character
        cell.creditLabel.isHidden = castCredit.character == nil
    }
    
    func configure(cell: PersonCreditCell, crewCredit: PersonCrewCreditViewModel) {
        cell.yearLabel.text = crewCredit.year
        cell.titleLabel.text = crewCredit.title
        
        cell.creditLabel.text = crewCredit.job
        cell.creditLabel.isHidden = crewCredit.job == nil
    }}
