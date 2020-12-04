//
//  AbstractMockStationsListViewModel.swift
//  irish-rail-poc-unit-tests
//
//  Created by Boyan Yankov on 2020-W49-04-Dec-Fri.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
@testable import irish_rail_poc

class AbstractMockStationsListViewModel: StationsListViewModel {
    
    func setViewModelConsumer(_ newValue: StationsListViewModelConsumer) {
        fatalError("not implemented!")
    }
    
    func fetchStations() {
        fatalError("not implemented!")
    }
    
    func items() -> [Station] {
        fatalError("not implemented!")
    }
    
    func item(at indexPath: IndexPath) -> Station? {
        fatalError("not implemented!")
    }
    
    func reset() {
        fatalError("not implemented!")
    }
    
    func isDisplayingSearchResults() -> Bool {
        fatalError("not implemented!")
    }
    
    func setDisplayingSearchResults(_ newValue: Bool) {
        fatalError("not implemented!")
    }
    
    func getSearchTerm() -> String {
        fatalError("not implemented!")
    }
    
    func setSearchTerm(_ newValue: String) {
        fatalError("not implemented!")
    }
    
    func filteredItems(by term: String) -> [Station] {
        fatalError("not implemented!")
    }
}
