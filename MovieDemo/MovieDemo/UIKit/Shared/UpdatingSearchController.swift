//
//  UpdatingSearchController.swift
//  DIExample
//
//  Created by Oscar Vernis on 06/11/22.
//

import UIKit
import Combine

class UpdatingSearchController: UISearchController {
    private var queryUpdated: ((String) -> Void)?
    private var queryPublisher = PassthroughSubject<String, Never>()
    private var cancellable: AnyCancellable?
    
    init(queryUpdated: ((String) -> Void)? = nil) {
        self.queryUpdated = queryUpdated
        super.init(searchResultsController: nil)
        
        cancellable = queryPublisher
            .sink { query in
                queryUpdated?(query)
            }

        self.searchResultsUpdater = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UpdatingSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        queryPublisher.send(query)
    }
}
