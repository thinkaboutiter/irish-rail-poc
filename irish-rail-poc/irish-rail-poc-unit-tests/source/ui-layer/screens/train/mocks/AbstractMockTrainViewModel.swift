//
//  AbstractMockTrainViewModel.swift
//  irish-rail-poc-unit-tests
//
//  MIT License
//
//  Copyright (c) 2020 Boyan Yankov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
