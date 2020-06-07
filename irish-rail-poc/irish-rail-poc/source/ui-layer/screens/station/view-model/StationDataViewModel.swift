//
//  StationDataViewModel.swift
//  irish-rail-poc
//
//  Created by Boyan Yankov on 2020-W24-08-Jun-Mon.
//  Copyright © 2020 boyankov@yahoo.com. All rights reserved.
//

import Foundation
import SimpleLogger

/// APIs for `ViewModel` to expose to `View`
protocol StationDataViewModel {
    var trainCode: String { get }
    var origin: String { get }
    var destination: String { get }
    var dueIn: Int { get }
    var late: Int { get }
    var expectedArrival: String { get }
}

struct StationDataViewModelImpl: StationDataViewModel {
    
    // MARK: - Properties
    private let stationData: StationData
    
    // MARK: - Initialization
    init(stationData: StationData) {
        self.stationData = stationData
    }
    
    // MARK: - StationDataViewModel protocol
    var trainCode: String {
        return self.stationData.trainCode
    }
    var origin: String {
        return self.stationData.origin
    }
    var destination: String {
        return self.stationData.destination
    }
    var dueIn: Int {
        return self.stationData.dueIn
    }
    var late: Int {
        return self.stationData.late
    }
    var expectedArrival: String {
        return self.stationData.expectedArrival
    }
}
