//
//  AbstractMockMapViewModel.swift
//  irish-rail-poc-unit-tests
//
//  Created by Boyan Yankov on 2020-W49-04-Dec-Fri.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
@testable import irish_rail_poc

class AbstractMockMapViewModel: MapViewModel {
    
    func setViewModelConsumer(_ newValue: MapViewModelConsumer) {
        fatalError("not implemented!")
    }
    
    func initialLatitude() -> Double {
        fatalError("not implemented!")
    }
    
    func initialLongitude() -> Double {
        fatalError("not implemented!")
    }
    
    func initialRadius() -> Double {
        fatalError("not implemented!")
    }
    
    func fetchStations() {
        fatalError("not implemented!")
    }
    
    func items() -> [Station] {
        fatalError("not implemented!")
    }
    
    func reset() {
        fatalError("not implemented!")
    }
}
