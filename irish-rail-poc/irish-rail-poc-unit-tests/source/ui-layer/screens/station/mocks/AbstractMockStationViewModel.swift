//
//  AbstractMockStationViewModel.swift
//  irish-rail-poc-unit-tests
//
//  Created by Boyan Yankov on 2020-W49-04-Dec-Fri.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
@testable import irish_rail_poc

class AbstractMockStationViewModel: StationViewModel {
    
    func setViewModelConsumer(_ newValue: StationViewModelConsumer) {
        fatalError("not implemented!")
    }
    
    func fetchStationData() {
        fatalError("not implemented!")
    }
    
    func cancelStationDataFetching() {
        fatalError("not implemented!")
    }
    
    func items() -> [StationData] {
        fatalError("not implemented!")
    }
    
    func item(at indexPath: IndexPath) -> StationData? {
        fatalError("not implemented!")
    }
    
    func station() -> Station {
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
    
    func filteredItems(by term: String) -> [StationData] {
        fatalError("not implemented!")
    }
}
