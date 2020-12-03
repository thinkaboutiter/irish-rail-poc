//
//  AbstractMockTrainViewModel.swift
//  irish-rail-poc-unit-tests
//
//  Created by Boyan Yankov on 2020-W49-04-Dec-Fri.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
@testable import irish_rail_poc

class AbstractMockTrainViewModel: TrainViewModel {
    
    func setViewModelConsumer(_ newValue: TrainViewModelConsumer) {
        fatalError("not implemented!")
    }
    
    func fetchTrainMovements() {
        fatalError("not implemented!")
    }
    
    func cancelTrainMovementsFetching() {
        fatalError("not implemented!")
    }
    
    func items() -> [TrainMovement] {
        fatalError("not implemented!")
    }
    
    func item(at indexPath: IndexPath) -> TrainMovement? {
        fatalError("not implemented!")
    }
    
    func stationData() -> StationData {
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
    
    func filteredItems(by term: String) -> [TrainMovement] {
        fatalError("not implemented!")
    }
}
